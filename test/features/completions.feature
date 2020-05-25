Feature: Shell Completion
    We want to get the correct completion on the CLI.

    Background:
        Given SDKMAN! candidate list is up to date
        And   candidate ant is installed at version 1.9.9
        And   candidate ant is installed at version 1.10.1
        And   candidate crash is installed

    Scenario: Command list correct
        When the user enters " " into the prompt
        Then completion should propose "b, broadcast, c, current, d, default, flush, h, help, i, install, list, ls, offline, rm, selfupdate, u, ug, uninstall, update, upgrade, use, v, version"

    Scenario Outline: Commands complete
        When the user enters "<cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd   | completions       |
            | b     | b, broadcast      |
            | c     | c, current        |
            | d     | d, default        |
            | f     | flush             |
            | h     | h, help           |
            | i     | i, install        |
            | in    | install           |
            | l     | list, ls          |
            | o     | offline           |
            | r     | rm                |
            | s     | selfupdate        |
            | u     | u, ug, uninstall, update, upgrade, use  |
            | un    | uninstall         |
            | up    | update, upgrade   |
            | us    | use               |
            | v     | v, version        |
            # Currently uncovered; include to catch new upstream commands:
            | a     |                   |
            | e     |                   |
            | g     |                   |
            | j     |                   |
            | k     |                   |
            | m     |                   |
            | n     |                   |
            | p     |                   |
            | q     |                   |
            | t     |                   |
            | w     |                   |
            | x     |                   |
            | y     |                   |
            | z     |                   |

    Scenario Outline: Completion for 'install'
        When the user enters "install <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd                       | completions       |
            | an                        | ant               |
            | xyz                       |                   |
            | 1.                        |                   |
            | gra                       | gradle, grails    |
            | grad                      | gradle            |
            | gradk                     |                   |
#            | ant 1.10.                 | 1.10.0, 1.10.1    |  # TODO: list installable versions --> issue #4
            | ant 1.10.2-mine /tm       | /tmp/             |
            | 'ant 1.10.2-mine /tmp '   |                   |

    Scenario Outline: Completion for 'uninstall'
        When the user enters "uninstall <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd           | completions   |
            |               | ant, crash    |
            | a             | ant           |
            | j             |               |
            | 1.            |               |
            | an            | ant           |  # installed
            | gr            |               |  # none installed
            | xyz           |               |  # no such candidate
            | 'an '         |               |  # no such candidate installed
            | 'ant 1'       | 1.10.1, 1.9.9 |
            | 'ant 1.10.'   | 1.10.1        |
            | 'ant 2'       |               |
            | 'ant 1.10.1 ' |               |

    Scenario Outline: Completion for 'list'
        When the user enters "list <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd    | completions |
            | an     | ant         |
            | xyz    |             |
            | 1.     |             |
            | 'ant ' |             |

    Scenario Outline: Completion for 'use'
        When the user enters "use <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd           | completions   |
            |               | ant, crash    |
            | an            | ant           |
            | j             |               |
            | 1.            |               |
            | 'ant '        | 1.10.1, 1.9.9 |
            | 'ant 1.10.1 ' |               |

    Scenario Outline: Completion for 'default'
        When the user enters "default <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd           | completions   |
            |               | ant, crash    |
            | an            | ant           |
            | j             |               |
            | 1.            |               |
            | 'ant '        | 1.10.1, 1.9.9 |
            | 'ant 1.10.1 ' |               |

    Scenario Outline: Completion for 'current'
        When the user enters "current <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd    | completions |
            | an     | ant         | # --> installed version
            | ja     | java        | # --> not installed
            | xyz    |             |
            | 1.     |             |
            | 'ant ' |             |

    Scenario Outline: Completion for 'upgrade'
        When the user enters "upgrade <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd    | completions |
            |        | ant, crash  |
            | an     | ant         |
            | j      |             |
            | 1.     |             |
            | 'ant ' |             |

    Scenario Outline: Completion for 'offline'
        When the user enters "offline <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd       | completions     |
            |           | disable, enable |
            | e         | enable          |
            | d         | disable         |
            | a         |                 |
            | 'enable ' |                 |

    Scenario Outline: Completion for 'selfupdate'
        When the user enters "selfupdate <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd      | completions |
            |          | force       |
            | f        | force       |
            | a        |             |
            | 'force ' |             |

    Scenario Outline: Completion for 'flush'
        When the user enters "flush <cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd     | completions               |
            |         | archives, broadcast, temp |
            | b       | broadcast                 |
            | a       | archives                  |
            | t       | temp                      |
            | x       |                           |
            | 'temp ' |                           |


    Scenario Outline: Completion for commands without parameters
        When the user enters "<cmd>" into the prompt
        Then completion should propose ""
        Examples:
            | cmd           |
            | 'version '    |
            | 'version a'   |
            | 'broadcast '  |
            | 'broadcast a' |
            | 'help '       |
            | 'help a'      |
            | 'update '     |
            | 'update a'    |
