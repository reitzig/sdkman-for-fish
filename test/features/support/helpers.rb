# frozen_string_literal: true

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
  candidates.key?(candidate) && (version.nil? || candidates[candidate].include?(version))
end

def run_bash_command(cmd)
  stdout, stderr, status = Open3.capture3("bash -c 'source \"$HOME/.sdkman/bin/sdkman-init.sh\"; #{cmd}'")
  unless status.success?
    warn(stderr)
    raise "Bash command failed: #{stderr}"
  end

  stdout
end

def run_fish_command(cmd)
  # NB: Fish errors out if we don't set terminal dimensions
  stdout, stderr, status = Open3.capture3("fish -c 'stty rows 80 columns 80; #{cmd}'")
  unless status.success?
    warn(stderr)
    raise 'Fish command failed'
  end

  stdout
end
