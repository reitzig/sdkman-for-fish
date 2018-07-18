set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

# Guard: SDKMAN! needs to be installed
if not test -f "$sdkman_init"
  exit 0
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