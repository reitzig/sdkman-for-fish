#!/usr/bin/fish

# Makes command and binaries from SDKMAN! available in fish.
# Delegates to bash for the `sdk` command.

# Copyright (c) 2018-2023 Raphael Reitzig
# MIT License (MIT)
# https://github.com/reitzig/sdkman-for-fish

# Account for custom install locations
if set -q __sdkman_custom_dir
    set -gx SDKMAN_DIR "$__sdkman_custom_dir"
end
# Guard: SDKMAN! needs to be installed
if set -q SDKMAN_DIR; and not test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    echo "WARNING: SDKMAN! installation path set to $SDKMAN_DIR, but no installation found there"
    exit 0
end

# Unless overridden, use the default location:
if not set -q SDKMAN_DIR
    set -gx SDKMAN_DIR "$HOME/.sdkman"
end

set __fish_sdkman_init "$SDKMAN_DIR/bin/sdkman-init.sh"

# Guard: SDKMAN! needs to be installed
if not test -f "$__fish_sdkman_init"
    exit 0
end

# Copied from https://github.com/jorgebucaran/fisher/blob/main/functions/fisher.fish to be consistent:
set --query fisher_path || set --local fisher_path $__fish_config_dir
set __fish_sdkman_noexport_init "$fisher_path/functions/__sdkman-noexport-init.sh"

# Hack for issue #19:
# Create version of sdkman-init that doesn't export any environment variables.
# Refresh if sdkman-init changed.
if  begin       not test -f "$__fish_sdkman_noexport_init";
          or    env test "$__fish_sdkman_init" -nt "$__fish_sdkman_noexport_init"
    end
    mkdir -p (dirname $__fish_sdkman_noexport_init)
    sed -E -e 's/^(\s*).*(export|to_path).*$/\1:/g' "$__fish_sdkman_init" \
        > "$__fish_sdkman_noexport_init"
end

# Runs the given command in bash, capturing some side effects
# and repeating them on the current fish shell.
# Returns the same status code as the given command.
function __fish_sdkman_run_in_bash
    # We need to leave stdin and stdout of sdk free for user interaction.
    # So, pipe relevant environment variables (which might have changed)
    # through a file.
    # But since now getting the exit code of sdk itself is a hassle,
    # pipe it as well.
    #
    # TODO: Can somebody get this to work without the overhead of a file?
    set pipe (mktemp)
    bash -c "$argv[1];
             echo -e \"\$?\" > $pipe;
             env | grep -e '^SDKMAN_\|^PATH' >> $pipe;
             env | grep -i -E \"^(`echo \${SDKMAN_CANDIDATES_CSV} | sed 's/,/|/g'`)_HOME\" >> $pipe;
             echo \"SDKMAN_OFFLINE_MODE=\${SDKMAN_OFFLINE_MODE}\" >> $pipe;
             echo \"SDKMAN_ENV=\${SDKMAN_ENV}\" >> $pipe" # it's not an environment variable!
    set bashDump (cat $pipe; rm $pipe)

    set sdkStatus $bashDump[1]
    set bashEnv $bashDump[2..-1]

    # If SDKMAN! succeeded, copy relevant environment variables
    # to the current shell (they might have changed)
    if [ $sdkStatus = 0 ]
        for line in $bashEnv
            set parts (string split "=" $line)
            set var $parts[1]
            set value (string join "=" $parts[2..-1])

            switch "$var"
            case "PATH"
                # Special treatment: need fish list instead
                # of colon-separated list.
                set value (string split : "$value")
            end

            if test -n value
                set -gx $var $value
                # Note: This makes SDKMAN_{OFFLINE_MODE,ENV} environment variables.
                #       That gives it the behaviour we _want_!
            end
        end
    end

    return $sdkStatus
end

# If this is a subshell of a(n initialized) fish owned by the same user,
# no initialization necessary.
# Otherwise:
if not set -q SDKMAN_CANDIDATES_DIR; or test (ls -ld "$SDKMAN_CANDIDATES_DIR" | awk '{print $3}') != (whoami)
    __fish_sdkman_run_in_bash "source $__fish_sdkman_init"
end

# Set up auto_env
if grep -q "^sdkman_auto_env=true" "$SDKMAN_DIR/etc/config"
    function __fish_sdkman_autoenv --on-variable PWD
        # Run the (modified) init script, which performs the checks and calls for us!
        __fish_sdkman_run_in_bash "source \"$__fish_sdkman_noexport_init\""

        set -x SDKMAN_OLD_PWD "$PWD" # needed by the Bash implementation
    end
end
