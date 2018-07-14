#!/usr/bin/fish

# Makes command and binaries from SDKMAN! available in fish.
# Delegates to bash for the `sdk` command.

# Copyright (c) 2018 Raphael Reitzig
# MIT License (MIT)
# https://github.com/reitzig/sdkman-for-fish

set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

if test -f "$sdkman_init"
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
    function sdk
        set bashEcho (bash -c "source $sdkman_init && sdk $argv && echo \"\$PATH\"")

        # If SDKMAN! succeeded, copy PATH here (might have changed)
        if [ $status = 0 ]
            set newPath (string split : "$bashEcho[-1]")
            set -gx PATH $newPath
        end

        # Print output of SDKMAN!
        string join \n $bashEcho[0..-2]
    end
end
