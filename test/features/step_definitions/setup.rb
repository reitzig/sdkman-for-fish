require 'fileutils'
require 'tempfile'

$index_updated = false # TODO: Hack since Cucumber doesn't have Feature-level hooks
Given(/^SDKMAN! candidate list is up to date$/) do
  unless $index_updated
    run_bash_command('sdk update')
    $index_updated = true
  end
end

Given(/^candidate (\w+) is installed at version (\d+(?:\.\d+)*)$/) do |candidate, version|
  # TODO: Can we mock-install instead?
  #       Something like
  #
  #         mkdir -p ${SDKMAN_CANDIDATES_DIR}/${candidate}/{version}/bin \
  #           && touch ${SDKMAN_CANDIDATES_DIR}/${candidate}/${version}/bin/${candidate} &&
  #           ln -s ${SDKMAN_CANDIDATES_DIR}/${candidate}/current ${SDKMAN_CANDIDATES_DIR}/${candidate}/${version}
  #
  #       should be quite enough to trick sdk as far as we need it to trick.
  #       Or is it?
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
  log `ls ~/.sdkman/candidates/#{candidate}`
  Dir["#{ENV['HOME']}/.sdkman/candidates/#{candidate}/*"].each do |candidate_dir|
    _uninstall_candidate_version(candidate_dir)
  end
  log `ls ~/.sdkman/candidates/#{candidate}`
end

Given(/^file ([a-zA-Z0-9\-_.\/]+) exists with content/) do |filename,content|
  FileUtils.mkdir_p(File.dirname(filename))
  File.write(filename, content)
end

$config_file = "#{ENV['HOME']}/.sdkman/etc/config"
$backup_config_file = nil
def _restore_config # called in After hook
  unless $backup_config_file.nil?
    FileUtils.mv($backup_config_file, $config_file)
    $backup_config_file = nil
  end
end

Given(/^SDKMAN! config sets ([a-z_]+) to (.*)$/) do |key,value|
  if $backup_config_file.nil?
    $backup_config_file = Tempfile.new('sdkman_config_backup')
    FileUtils.cp($config_file, $backup_config_file)
  end

  config = File.readlines($config_file).map { |line| line.split("=").map { |v| v.strip } }.to_h
  config[key] = value
  new_config_string = config.map { |k,v| "#{k}=#{v}" }.join("\n")

  File.write($config_file, new_config_string)
end
