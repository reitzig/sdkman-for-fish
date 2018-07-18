# Guard: SDKMAN! needs to be installed
if not test -f "$__fish_sdkman_init"
  exit 0
end

# Declare the sdk command for fish
function sdk -d "Manage SDKs"
    __fish_sdkman_run_in_bash "source \"$__fish_sdkman_noexport_init\" && sdk $argv"
    # __fish_sdkman_run_in_bash "source \"$__fish_sdkman_init\" && sdk $argv" 
    #  --> issue #19
end