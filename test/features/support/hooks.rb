require_relative '../step_definitions/setup'
require_relative '../step_definitions/corner_cases.rb'

BeforeAll do
  run_bash_command('sdk update')
end

After do |scenario|
  _remove_fish_configs
  _restore_fish_config
  _restore_config
  _restore_install
end

# Uninstall all SDKMAN! candidates
AfterAll do
  Dir["#{ENV['HOME']}/.sdkman/candidates/*/*"].each do |candidate_dir|
    _uninstall_candidate_version(candidate_dir)
  end
end
