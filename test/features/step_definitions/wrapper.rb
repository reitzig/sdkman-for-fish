# frozen_string_literal: true

module WrapperHelper
  def reject_then_select(lines, exclude, select)
    lines.select do |e|
      (exclude.nil? || e !~ exclude) && e =~ select
    end.sort
  end

  def compare_env(exclude, include)
    env_bash = reject_then_select(@response_bash[:env], exclude, include)
    env_fish = reject_then_select(@response_fish[:env], exclude, include)
    expect(env_fish).to eq(env_bash)
  end
end
World WrapperHelper

When('we run {string} in Bash and Fish') do |command|
  @response_bash = run_bash_command(command)
  @response_fish = run_fish_command(command)
end

Then('the exit code is the same') do
  expect(@response_fish[:status]).to eq(@response_bash[:status])
end

Then('the output is the same') do
  %i[stdout stderr].each do |out|
    expect(@response_fish[out]).to eq(@response_bash[out])
  end
end

Then('environment variable(s) {env_glob} is/are the same') do |pattern|
  compare_env(nil, pattern)
end

Then('environment variable(s) {env_glob} is/are the same except for {env_glob}') do |pattern, exclude_pattern|
  compare_env(exclude_pattern, pattern)
end
