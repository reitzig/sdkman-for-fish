# frozen_string_literal: true

require 'fileutils'
require 'tempfile'

module GeneralHelper
end
World GeneralHelper

When('we run fish script') do |script_content|
  script_file = Tempfile.new('fish_script')
  File.write(script_file, script_content)

  out, status = Open3.capture2e($test_env, "fish #{script_file.path}")
  unless status.success?
    warn(out)
    raise "Fish command failed: #{out}"
  end

  @output_fish_script = out.strip
end

Then(/^the output is$/) do |text|
  expect(@output_fish_script).to eq(text.strip)
end

When('we run {string} in Fish') do |command|
  @response = run_fish_command(command)
end

Then('the exit code is {int}') do |code|
  expect(@response[:status]).to eq(code)
end

Then(/^environment variable ([A-Z_]+) has value "([^"]+)"$/) do |key, value|
  expect(@response[:env][key]).to eq(value)
end

And('the output contains {string}') do |content|
  output = @response[:stdout]
             .select { |line| !line.strip.empty? }
             .map { |line| line.strip }
  expect(output).to include(content)
end

Then(/^file ([a-zA-Z0-9\-_.\/]+) contains$/) do |file,content|
  expect(File.readlines(file).join("").strip).to eq(content.strip)
end
