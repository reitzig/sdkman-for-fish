$index_updated = false # TODO: Hack since Cucumber doesn't have Feature-level hooks
Given(/^SDKMAN! candidate list is up to date$/) do
  unless $index_updated
    run_bash_command('sdk update')
    $index_updated = true
  end
end

Given(/^candidate (\w+) is installed at version (\d+(?:\.\d+)*)$/) do |candidate, version|
  run_bash_command("sdk install #{candidate} #{version}") unless installed?(candidate, version)
end

Given(/^candidate (\w+) is installed$/) do |candidate|
  run_bash_command("sdk install #{candidate}") unless installed?(candidate)
end

def _uninstall_candidate_version(candidate_dir)
  %r{/([^/]+)/([^/]+)$}.match(candidate_dir) do |match|
    candidate = match[1]
    version = match[2]
    run_bash_command("sdk rm #{candidate} #{version}") unless version == 'current'
  end
end

When(/^candidate (\w+) is uninstalled$/) do |candidate|
  puts `ls ~/.sdkman/candidates/#{candidate}`
  Dir["#{ENV['HOME']}/.sdkman/candidates/#{candidate}/*"].each do |candidate_dir|
    _uninstall_candidate_version(candidate_dir)
  end
  puts `ls ~/.sdkman/candidates/#{candidate}`
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
