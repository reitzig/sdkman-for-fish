# frozen_string_literal: true

require 'open3'

module CompletionHelper
  def complete(cmd)
    completions = run_fish_command("complete -C\"sdk #{cmd}\"")[:stdout]

    completions.map { |line| line.split(/\s+/)[0].strip }
    # TODO: Why do we get duplicates in the Docker container?
  end
end
World CompletionHelper

When('the user enters {string} into the prompt') do |cmd|
  @response = complete(cmd.gsub(/["']/, ''))
end

Then('completion should propose {string}') do |completions|
  completions = completions.split(',').map(&:strip)
  expect(@response).to include(*completions)
end

Then('completion should not propose {patterns}') do |exclusions_patterns|
  exclusions_patterns.each do |p|
    @response.each do |r|
      expect(r).not_to match(p)
    end
  end
end
