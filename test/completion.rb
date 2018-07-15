#!/usr/bin/env ruby

# Includes completion examples with the intent to cover 
# all sdk commands
# Beware, pasta follows.

test_cases = {
    # Basic commands (in the order of `sdk help`):
    "i" => ["i", "install"],
    "u" => ["u", "ug", "uninstall", "update", "upgrade", "use"],
    "r" => ["rm"],
    "l" => ["list", "ls"],
    "d" => ["d", "default"],
    "c" => ["c", "current"],
    "v" => ["v", "version"],
    "b" => ["b", "broadcast"],
    "h" => ["h", "help"],
    "o" => ["offline"],
    "s" => ["selfupdate"],
    "f" => ["flush"],
    # Currently uncovered; include to catch new upstream commands:
    "a" => [],
    "e" => [],
    "g" => [],
    "j" => [],
    "k" => [],
    "m" => [],
    "n" => [],
    "p" => [],
    "q" => [],
    "t" => [],
    "w" => [],
    "x" => [],
    "y" => [],
    "z" => [],

    # Second parameters complete correctly
    "install an" => ["ant"],
    "install xyz" => [],
    "install 1." => [],

    "uninstall " => ["ant"],
    "uninstall an" => ["ant"],
    "uninstall j" => [],
    "uninstall 1." => [],

    "list an" => ["ant"],
    "list xyz" => [],
    "list 1." => [],

    "use " => ["ant"],
    "use an" => ["ant"],
    "use j" => [],
    "use 1." => [],

    "default " => ["ant"],
    "default an" => ["ant"],
    "default j" => [],
    "default 1." => [],

    "current an" => ["ant"],
    "current xyz" => [],
    # "default j" => [], # TODO: should uninstalled candidates complete here?
    "current 1." => [],

    "upgrade " => ["ant"],
    "upgrade an" => ["ant"],
    "upgrade j" => [],
    "upgrade 1." => [],

    "version " => [],
    "version a" => [],

    "broadcast " => [],
    "broadcast a" => [],

    "help " => [],
    "help a" => [],

    "offline " => ["enable", "disable"],
    "offline a" => [],

    "selfupdate " => ["force"],
    "selfupdate a" => [],

    "update " => [],
    "update a" => [],

    "flush " => ["broadcast", "archives", "temp"],
    "flush a" => [],

    # Third parameters complete correctly
    #"install ant 1.10." => ["1.10.0", "1.10.1"], # TODO: issue #4
    "uninstall ant 1.10." => ["1.10.1"],
    "list " => [],
    "use ant " => ["1.9.9", "1.10.1"],
    "default ant " => ["1.9.9", "1.10.1"],
    "current " => [],
    "upgrade " => [],
    "offline " => [],
    "selfupdate " => [],
    "flush " => [],

    # Fourth parameters complete correctly
    "install ant 1.10.2 " => [],
    "uninstall ant 1.10.1 " => [],
    "use ant 1.10.1 " => [],
    "default ant 1.10.1 " => [],

    # Lists of all candidates work
    "install gr" => ["gradle", "grails", "groovy", "groovyserv"],
    "install grad" => ["gradle"],
    "install gradk" => [],

    # Lists of installed candidates work
    "uninstall an" => ["ant"],
    "uninstall gr" => [],
    "uninstall xyz" => [],

    # List of all versions work
    # TODO

    # List of installed versions work
    "uninstall ant 1" => ["1.9.9", "1.10.1"],
    "uninstall ant 2" => [],
    "uninstall vertx " => [],
    "uninstall an " => []
}

def fish_command(prompt)
    # Fish errors out if we don't set terminal dimensions
    "fish -c 'stty rows 80 columns 80; complete -C\"sdk #{prompt}\"'"
end

def extract(completion_output)
    completion_output.split("\n").map { |line| 
        line.split(/\s+/)[0].strip 
    }
end

puts "Testing sdk completions"
failures = 0
test_cases.each { |prompt, results|
    results.sort!

    print "  Test: 'sdk #{prompt}'"
    completions = extract(`#{fish_command(prompt)}`).sort
    if completions != results
        puts " -- bad!"
        puts "  - Expected: #{results}"
        puts "  - Actual:   #{completions}"
        failures += 1
    else
        puts " -- ok!"
    end
}

puts "Ran #{test_cases.size} checks each."
puts "#{failures}/#{test_cases.size} checks failed."
exit failures > 0 ? 1 : 0