# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'

def list_installed_candidates
  candidates = {}

  Dir["#{ENV['HOME']}/.sdkman/candidates/*/*"].each do |candidate_dir|
    %r{/([^/]+)/([^/]+)$}.match(candidate_dir) do |match|
      candidate = match[1]
      version = match[2]
      candidates[candidate] = [] unless candidates.key?(candidate)
      candidates[candidate].push version unless version == 'current'
    end
  end

  candidates
end

def installed?(candidate, version = nil)
  candidates = list_installed_candidates
  candidates.key?(candidate) \
                  && (version.nil? || candidates[candidate].include?(version))
end

def run_bash_command(cmd)
  Dir.mktmpdir(%w[sdkman-for-fish-test_ _fish]) do |tmp_dir|
    files = %i[status stdout stderr env].map { |s|
      [s, FileUtils.touch("#{tmp_dir}/#{s}")[0]]
    }.to_h

    out, status = Open3.capture2e(<<~BASH
      bash -c 'source "#{ENV['HOME']}/.sdkman/bin/sdkman-init.sh" && \
               #{cmd} > #{files[:stdout]} 2> #{files[:stderr]}; \
               echo "$?" > #{files[:status]}; \
               env > #{files[:env]}; \
              '
    BASH
    )

    unless status.success?
      warn(out)
      raise "Bash command failed: #{out}"
    end

    {
      status: File.read(files[:status]).to_i,
      stdout: File.readlines(files[:stdout]),
      stderr: File.readlines(files[:stderr]),
      env: File.readlines(files[:env])
    }
  end
end

# # For nicer diffs: one entry per line, sorted
# string split ":" (cat path_bash) | sort > path_bash
# string split ":" (cat path_fish) \
#       | string split " " \
#       | sort > path_fish
# # split by spaces for fish 2.*

def run_fish_command(cmd)
  Dir.mktmpdir(%w[sdkman-for-fish-test_ _fish]) do |tmp_dir|
    files = %i[status stdout stderr env].map { |s|
      [s, FileUtils.touch("#{tmp_dir}/#{s}")[0]]
    }.to_h

    out, status = Open3.capture2e(<<~FISH
      fish -c '#{cmd} > #{files[:stdout]} ^ #{files[:stderr]}; \
               echo $status > #{files[:status]}; \
               env > #{files[:env]}; \
              '
    FISH
    )

    unless status.success?
      warn(out)
      raise "Fish command failed: #{out}"
    end

    {
      status: File.read(files[:status]).to_i,
      stdout: File.readlines(files[:stdout]),
      stderr: File.readlines(files[:stderr]),
      env: File.readlines(files[:env])
    }
  end
end
