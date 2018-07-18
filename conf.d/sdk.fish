#!/usr/bin/fish

# Makes command and binaries from SDKMAN! available in fish.
# Delegates to bash for the `sdk` command.

# Copyright (c) 2018 Raphael Reitzig
# MIT License (MIT)
# https://github.com/reitzig/sdkman-for-fish

set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

# Guard: SDKMAN! needs to be installed
if not test -f "$sdkman_init"
    exit 0
end

# Add binaries from installed SDKs to PATH, if necessary
switch "$PATH"
case "*$HOME/.sdkman/candidates/*"
    # This is a subshell, SDKMAN! binaries already in path.
case '*'
    # No SDKMAN! in PATH yet, so add candidate binaries
    for ITEM in $HOME/.sdkman/candidates/*/current ;
        set -gx PATH $PATH $ITEM/bin
    end
end


