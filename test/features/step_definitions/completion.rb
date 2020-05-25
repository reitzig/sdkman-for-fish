# frozen_string_literal: true

require 'open3'

module CompletionHelper
  def complete(cmd)
    completions = run_fish_command("complete -C\"sdk #{cmd}\"")

    completions.split("\n") \
               .map { |line| line.split(/\s+/)[0].strip } \
               .sort \
               .uniq \
               .join(', ')
    # TODO: Why do we get duplicates in the Docker container?
    #       --> remove uniq
  end
end
World CompletionHelper

When('the user enters {string} into the prompt') do |cmd|
  @response = complete(cmd.gsub(/["']/, ''))
end

Then(/^completion should propose "(.*)"$/) do |completions|
  expect(@response).to eq(completions)
end
