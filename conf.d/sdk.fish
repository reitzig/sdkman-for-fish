#!/usr/bin/fish

set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

if test -f "$sdkman_init"
    # Add candidate binaries to PATH
    for ITEM in $HOME/.sdkman/candidates/* ;
        set -gx PATH $PATH $ITEM/current/bin
    end

    # Declare the sdk command for fish
    function sdk
        bash -c "source $sdkman_init && sdk $argv"
    end
end