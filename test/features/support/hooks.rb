require_relative '../step_definitions/setup'

After do |scenario|
  _restore_config
end

# Uninstall all SDKMAN! candidates
# TODO: Run after every scenario, this makes tests very slow.
#       Currently, Cucumber doesn't have Feature-level hooks, so we have to work around:
#       --> install only if not already installed;
#           if the test needs a candidate to _not_ be there, make it explicit.
#       --> clean up after _all_ features at least
at_exit do
  Dir["#{ENV['HOME']}/.sdkman/candidates/*/*"].each do |candidate_dir|
    _uninstall_candidate_version(candidate_dir)
  end
end
