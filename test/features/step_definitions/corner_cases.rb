# frozen_string_literal: true

require 'fileutils'

Given('environment variable {env_name} is not set') do |name|
  @name = name
  @expect_intermediate_value = false
  @command = <<~BASH
    ( \\
      env | grep -E "^#{name}="; \\
      export -n #{name}; \\
      env | grep -E "^#{name}="; \\
  BASH
end

Given('environment variable {env_name} is set to {string}') do |name, new_value|
  @name = name
  @expect_intermediate_value = true
  @command = <<~BASH
    ( \\
      env | grep -E "^#{name}="; \\
      export #{name}=#{new_value}; \\
      env | grep -E "^#{name}="; \\
  BASH
end

$install_default = "#{ENV['HOME']}/.sdkman"
$install_custom = nil
$install_backup = "#{$install_default}_bak"
Given(/^SDKMAN! is installed at (.*)$/) do |path|
  $install_custom = path
  FileUtils.cp_r($install_default, $install_custom)
  log "Backing up #{$install_default} at #{$install_backup}"
  FileUtils.mv($install_default, $install_backup)
end

def _restore_install  # called in After hook
  unless $install_custom.nil?
    log "Removing #{$install_custom}"
    FileUtils.rm_rf($install_custom)
    $install_custom = nil
    log "Restoring #{$install_default} from #{$install_backup}"
    FileUtils.mv($install_backup, $install_default)
  end
end

When('a new Fish shell is launched') do
  @command += <<~BASH
      fish -lc "env | grep -E \\"^#{@name}=\\"" \\
    ) \\
  BASH

  @response = run_bash_command(@command)
end

Then('environment variable {env_name} has the original value') do |name|
  expect(name).to eq(@name) # otherwise the test doesn't make sense

  if @expect_intermediate_value
    expect(@response[:stdout].count).to eq(3)
    expect(@response[:stdout][0]).to_not eq(@response[:stdout][1]) # destruction effective
  else
    expect(@response[:stdout].count).to eq(2)
  end

  expect(@response[:stdout][-1]).to eq(@response[:stdout][0]) # reinitialization effective
end

Then('environment variable {env_name} cannot contain {string}') do |name, value|
  env = run_fish_command('echo noop')[:env]
  expect(env[name]).to_not match(/#{Regexp.escape(value)}/)
end
