# frozen_string_literal: true

require 'fileutils'

Given(/^SDKMAN! is not installed$/) do
  FileUtils.rm_rf("#{$test_env['SDKMAN_DIR']}")
end

When('sdk is called and user answers {string}') do |answer|
  run_fish_command("echo '#{answer}' | sdk version")
end

Then(/^SDKMAN! is absent$/) do
  expect(Dir["#{$test_env['SDKMAN_DIR']}/*"].count).to eq(0)
  response = run_bash_command("sdk version")
  expect(response[:status]).to_not eq(0)
end

Then('SDKMAN! is present') do
  expect(Dir["#{$test_env['SDKMAN_DIR']}/*"].count).to be > 1
  response = run_bash_command("sdk version")
  expect(response[:status]).to eq(0)
end
