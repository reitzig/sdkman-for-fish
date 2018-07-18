set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

# Guard: SDKMAN! needs to be installed
if not test -f "$sdkman_init"
  exit 0
end

# Runs the given command in bash, capturing some side effects
# and repeating them on the current fish shell.
# Returns the same status code as the given command.
function __fish_sdkman_run_in_bash
    # We need to leave stdin and stdout of sdk free for user interaction.
    # So, pipe PATH (which might have changed) through a file.
    # Now, getting the exit code of sdk itself is a hassle so pipe it as well.
    # TODO: Can somebody get this to work without the overhead of a file?
    set pipe (mktemp)
    bash -c "$argv[1]; echo -e \"\$PATH\n\$?\" > $pipe"
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

# Declare the sdk command for fish
function sdk -d "Manage SDKs"
    __fish_sdkman_run_in_bash "source $sdkman_init && sdk $argv"
end