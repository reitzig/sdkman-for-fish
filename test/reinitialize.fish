# If either of
#   - $SDKMAN_DIR is unset
#   - $SDKMAN_DIR points to a directory not owned by the current user
# is true, sdkman-for-fish should run sdkman's init script.

# Assumes sdkman-for-fish is installed
set proper_value "$SDKMAN_DIR"

begin
    set -e SDKMAN_DIR
    set in_new_shell (fish -lc 'echo $SDKMAN_DIR')
    if [ "$in_new_shell" != "$proper_value" ]
      echo "SDKMAN_DIR initialized to $in_new_shell instead of $proper_value"
      exit 1
    end
end

begin
    set -x SDKMAN_DIR "/" # belongs to root, who hopefully doesn't run this
    set in_new_shell (fish -lc 'echo $SDKMAN_DIR')
    if [ "$in_new_shell" != "$proper_value" ]
      echo "SDKMAN_DIR reinitialized to $in_new_shell instead of $proper_value"
      exit 1
    end
end
