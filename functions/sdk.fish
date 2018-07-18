set sdkman_init "$HOME/.sdkman/bin/sdkman-init.sh"

# Guard: SDKMAN! needs to be installed
if not test -f "$sdkman_init"
  exit 0
end

# Declare the sdk command for fish
function sdk -d "Manage SDKs"
    __fish_sdkman_run_in_bash "source $sdkman_init && sdk $argv"
end