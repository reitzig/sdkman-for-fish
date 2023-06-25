# frozen_string_literal: true

require 'fileutils'
require 'tempfile'

module GeneralHelper
end
World GeneralHelper

When('we run fish script') do |script_content|
  script_file = Tempfile.new('fish_script')
  File.write(script_file, script_content)

  out, status = Open3.capture2e("fish #{script_file.path}")
  unless status.success?
    warn(out)
    raise "Fish command failed: #{out}"
  end

  @response_fish_script = out.strip
end

Then(/^the output is$/) do |text|
  expect(@response_fish_script).to eq(text.strip)
end

Then(/^file ([a-zA-Z0-9\-_.\/]+) contains$/) do |file,content|
  expect(File.readlines(file).join("").strip).to eq(content.strip)
end
