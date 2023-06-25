$run_with_real_install = (ENV['RUN_WITH_REAL_INSTALL'] || 'true') == 'true'
$shared_setup = (ENV['SHARED_TEST_SETUP'] || 'false') == 'true'
$test_env = {}

if $run_with_real_install
  # nothing to do except set the flag
  puts "Running with real packages installs through SDKMAN! -- beware!"
  $test_env = {
    'SDKMAN_DIR' => "#{ENV['HOME']}/.sdkman",
    'SDKMAN_CANDIDATES_DIR' => "#{ENV['HOME']}/.sdkman/candidates",
  }
else
  puts "Running with mocked package installs"
  # TODO: Put SDKMAN! in a temp dir -- but how to change $SDKMAN_(CANDIDATES_)DIR?
  # For now, set the env vars to the defaults so our setup methods work
  $test_env = {
    'SDKMAN_DIR' => "#{ENV['HOME']}/.sdkman",
    'SDKMAN_CANDIDATES_DIR' => "#{ENV['HOME']}/.sdkman/candidates",
  }
end
