#!/usr/bin/fish

# Makes command and binaries from SDKMAN! available in fish.
# Delegates to bash for the `sdk` command.

# Copyright (c) 2018 Raphael Reitzig
# MIT License (MIT)
# https://github.com/reitzig/sdkman-for-fish

set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

# Don't do anything if SDKMAN! isn't installed, because that would be silly
if test -f "$sdkman_init"
    # Add binaries from installed SDKs to PATH, if necessary
    switch "$PATH"
    case "*$HOME/.sdkman/candidates/*"
        # This is a subshell, SDKMAN! binaries already in path.
    case '*'
        # No SDKMAN! in PATH yet, so add candidate binaries
        for ITEM in $HOME/.sdkman/candidates/* ;
            set -gx PATH $PATH $ITEM/current/bin
        end
    end

    # Declare the sdk command for fish
    function sdk -d "Manage SDKs"
        # We need to leave stdin and stdout of sdk free for user interaction.
        # So, pipe PATH (which might have changed) through a file.
        # Now, getting the exit code of sdk itself is a hassle so pipe it as well.
        # TODO: Can somebody get this to work without the overhead of a file?
        set pipe (mktemp)
        bash -c "source $sdkman_init && sdk $argv; echo -e \"\$PATH\n\$?\" > $pipe"
        set bashDump (cat $pipe; rm $pipe)

        set bashPath $bashDump[1]
        set sdkStatus $bashDump[2]
        # If SDKMAN! succeeded, copy PATH here (might have changed)
        if [ $sdkStatus = 0 ]
            set newPath (string split : "$bashPath")
            set -gx PATH $newPath
        end

        return $sdkStatus
    end
end
