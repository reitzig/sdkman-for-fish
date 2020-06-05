# Defines autocompletion for SDKMAN!

# Copyright (c) 2018 Raphael Reitzig
# MIT License (MIT)
# https://github.com/reitzig/sdkman-for-fish

# Guard: SDKMAN! needs to be installed
if not test -f "$HOME/.sdkman/bin/sdkman-init.sh"
    exit 0
end

# # # # # #
# Completion trigger predicates
# # # # # #

# Test if there is no command
function __fish_sdkman_no_command
    set cmd (commandline -opc)

    if [ (count $cmd) -eq 1 ]
        return 0
    end
    return 1
end

# Test if the main command matches one of the parameters
function __fish_sdkman_using_command
    set cmd (commandline -opc)

    if [ (count $cmd) -eq 2 ]
        if contains $cmd[2] $argv
            return 0
        end
    end
    return 1
end

function __fish_sdkman_specifying_candidate
    set cmd (commandline -opc)

    if [ (count $cmd) -eq 3 ] # currently, sdk does not support multiple versions
        if contains $cmd[2] $argv
            return 0
        end
    end
    return 1
end

function __fish_sdkman_command_has_enough_parameters
    set cmd (commandline -opc)

    if [ (count $cmd) -ge (math $argv[1] + 2) ]; and contains $cmd[2] $argv[2..-1]
        return 0
    end
    return 1
end

# # # # # #
# Data collectors
# # # # # #

function __fish_sdkman_candidates
    cat "$HOME"/.sdkman/var/candidates | tr ',' '\n'
end

function __fish_sdkman_candidates_with_versions
    set regexpHome (string replace -a '/' '\\/' "$HOME/")

    find "$HOME"/.sdkman/candidates/ -mindepth 2 -maxdepth 2 -name '*current' \
    | awk -F '/' '{ print $(NF-1) }' \
    | sort -u
end

function __fish_sdkman_installed_versions
    set cmd (commandline -opc)
    if [ -d "$HOME"/.sdkman/candidates/$cmd[3]/current ]
        ls -v1 "$HOME"/.sdkman/candidates/$cmd[3] | grep -v current
    end
end

# # # # # #
# Completion specification
# # # # # #

# install
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'i install' \
    -d 'Install new version'
complete -c sdk -f -n '__fish_sdkman_using_command i install' \
        -a "(__fish_sdkman_candidates)"
# TODO complete available versions --> issue #4
complete -c sdk -f -n '__fish_sdkman_specifying_candidate i install' \
            -a 'a.b.c' \
            -d "version list unavailable"
complete -c sdk -f -n '__fish_sdkman_specifying_candidate i install' \
            -a 'x.y.z' \
            -d "Specify path to install custom version."
# Implicit: complete files as fourth parameter
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 3 i install'
                    # block

# uninstall
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'rm uninstall' -d 'Uninstall version'
complete -c sdk -f -n '__fish_sdkman_using_command rm uninstall' \
        -a "(__fish_sdkman_candidates_with_versions)"
complete -c sdk -f -n '__fish_sdkman_specifying_candidate rm uninstall' \
            -a "(__fish_sdkman_installed_versions)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 2 rm uninstall'
                # block

# list
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'ls list' \
    -d 'List versions'
complete -c sdk -f -n '__fish_sdkman_using_command ls list' \
        -a "(__fish_sdkman_candidates)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 ls list'
            # block

# use
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'u use' \
    -d 'Use specific version'
complete -c sdk -f -n '__fish_sdkman_using_command u use' \
        -a "(__fish_sdkman_candidates_with_versions)"
complete -c sdk -f -n '__fish_sdkman_specifying_candidate u use' \
            -a "(__fish_sdkman_installed_versions)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 2 u use'
                # block

# default
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'd default' \
    -d 'Set default version'
complete -c sdk -f -n '__fish_sdkman_using_command d default' \
        -a "(__fish_sdkman_candidates_with_versions)"
complete -c sdk -f -n '__fish_sdkman_specifying_candidate d default' \
            -a "(__fish_sdkman_installed_versions)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 2 d default'
                # block

# current
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'c current' \
    -d 'Display current version'
complete -c sdk -f -n '__fish_sdkman_using_command c current' \
        -a "(__fish_sdkman_candidates)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 c current'
            # block

# upgrade
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'ug upgrade' \
    -d 'Display what is outdated'
complete -c sdk -f -n '__fish_sdkman_using_command ug upgrade' \
        -a "(__fish_sdkman_candidates_with_versions)"
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 ug upgrade'
            # block

# version
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'v version' \
    -d 'Display version'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 0 v version'
        # block

# broadcast
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'b broadcast' \
    -d 'Display broadcast message'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 0 b broadcast'
        # block

# help
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'h help' \
    -d 'Display help message'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 0 h help'
        # block

# offline
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'offline' \
    -d 'Set offline status'
complete -c sdk -f -n '__fish_sdkman_using_command offline' \
        -a 'enable' \
        -d 'Make sdk work while offline'
complete -c sdk -f -n '__fish_sdkman_using_command offline' \
        -a 'disable' \
        -d 'Turn on all features'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 offline'
            # block

# selfupdate
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'selfupdate' \
    -d 'Update sdk'
complete -c sdk -f -n '__fish_sdkman_using_command selfupdate' \
        -a 'force' \
        -d 'Force re-install of current version'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 selfupdate'
            # block

# update
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'update' \
    -d 'Reload the candidate list'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 0 update'
        # block

# flush
complete -c sdk -f -n '__fish_sdkman_no_command' \
    -a 'flush' \
    -d 'Clear out caches'
complete -c sdk -f -n '__fish_sdkman_using_command flush' \
        -a 'broadcast' \
        -d 'Re-download news'
complete -c sdk -f -n '__fish_sdkman_using_command flush' \
        -a 'archives' \
        -d 'Remove downloads'
complete -c sdk -f -n '__fish_sdkman_using_command flush' \
        -a 'temp' \
        -d 'Clear installation prep folder'
complete -c sdk -f -n '__fish_sdkman_command_has_enough_parameters 1 flush'
            # block
