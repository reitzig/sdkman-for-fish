# sdkman autocompletion

function __fish_sdkman_no_command --description 'Test if sdkman has yet to be given the main command'
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    return 0
  end
  return 1
end

function __fish_sdkman_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 2 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_sdkman_using_subcommand
  set cmd (commandline -opc)
  set cmd_main $argv[1]
  set cmd_sub $argv[2]

  if [ (count $cmd) -gt 2 ]
    if [ $cmd_main = $cmd[2] ]; and [ $cmd_sub = $cmd[3] ]
      return 0
    end
  end
  return 1
end

function __fish_sdkman_specifying_candidate
  set cmd (commandline -opc)

  if [ (count $cmd) -gt 2 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_sdkman_candidates
  cat ~/.sdkman/var/candidates | tr ',' '\n'
end

function __fish_sdkman_installed_versions
  set cmd (commandline -opc)
  ls -v1 ~/.sdkman/candidates/$cmd[3] | grep -v current
end

# install
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'install' -d 'Install new version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'i' -d 'Install new version'
complete -c sdk -f -n '__fish_sdkman_using_command install' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command i' -a "(__fish_sdkman_candidates)"  

# uninstall
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'uninstall' -d 'Uninstall version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'rm' -d 'Uninstall version'
complete -c sdk -f -n '__fish_sdkman_using_command uninstall' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command rm' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_specifying_candidate uninstall' -a "(__fish_sdkman_installed_versions)" 
complete -c sdk -f -n '__fish_sdkman_specifying_candidate rm' -a "(__fish_sdkman_installed_versions)" 

# list
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'list' -d 'List versions'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'ls' -d 'List versions'
complete -c sdk -f -n '__fish_sdkman_using_command list' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command ls' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_specifying_candidate list' -a "(__fish_sdkman_installed_versions)" 
complete -c sdk -f -n '__fish_sdkman_specifying_candidate ls' -a "(__fish_sdkman_installed_versions)" 

# use
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'use' -d 'Use specific version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'u' -d 'Use specific version'
complete -c sdk -f -n '__fish_sdkman_using_command use' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command u' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_specifying_candidate use' -a "(__fish_sdkman_installed_versions)" 
complete -c sdk -f -n '__fish_sdkman_specifying_candidate u' -a "(__fish_sdkman_installed_versions)" 

# default
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'default' -d 'Set default version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'd' -d 'Set default version'
complete -c sdk -f -n '__fish_sdkman_using_command default' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command d' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_specifying_candidate default' -a "(__fish_sdkman_installed_versions)" 
complete -c sdk -f -n '__fish_sdkman_specifying_candidate d' -a "(__fish_sdkman_installed_versions)" 

# current
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'current' -d 'Display current version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'c' -d 'Display current version'
complete -c sdk -f -n '__fish_sdkman_using_command current' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_using_command c' -a "(__fish_sdkman_candidates)"  
complete -c sdk -f -n '__fish_sdkman_specifying_candidate current' -a "(__fish_sdkman_installed_versions)" 
complete -c sdk -f -n '__fish_sdkman_specifying_candidate c' -a "(__fish_sdkman_installed_versions)" 

# upgrade
# TODO

# version
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'version' -d 'Display version'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'v' -d 'Display version'
complete -c sdk -f -n '__fish_sdkman_using_command version' 
complete -c sdk -f -n '__fish_sdkman_using_command v' 

# broadcast
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'broadcast' -d 'Display broadcast message'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'b' -d 'Display broadcast message'
complete -c sdk -f -n '__fish_sdkman_using_command broadcast' 
complete -c sdk -f -n '__fish_sdkman_using_command b' 

# help
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'help' -d 'Display help message'
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'h' -d 'Display help message'
complete -c sdk -f -n '__fish_sdkman_using_command help' 
complete -c sdk -f -n '__fish_sdkman_using_command h' 

# offline
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'offline' -d 'Set offline status'
complete -c sdk -f -n '__fish_sdkman_using_command offline' -a 'enable disable'

# selfupdate
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'selfupdate' -d 'Update sdkman'
complete -c sdk -f -n '__fish_sdkman_using_command selfupdate' -a 'force'

# update
# TODO

# flush
complete -c sdk -f -n '__fish_sdkman_no_command' -a 'flush' -d 'Clear out cache'
complete -c sdk -f -n '__fish_sdkman_using_command flush' -a 'candidates broadcast archives temp'
