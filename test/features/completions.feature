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
        But  completion should not propose <exclusions>
        Examples:
            | cmd | completions                            | exclusions |
            | b   | b, broadcast                           | /^[^b]+$/  |
            | c   | c, current                             | /^[^c]+$/  |
            | d   | d, default                             | /^[^d]+$/  |
            | e   | e, env                                 | /^[^e]+$/  |
            | f   | flush                                  | /^[^f]+$/  |
            | h   | h, help, home                          | /^[^h]+$/  |
            | he  | help                                   |            |
            | ho  | home                                   |            |
            | i   | i, install                             | /^[^i]+$/  |
            | in  | install                                |            |
            | l   | list, ls                               | /^[^l]+$/  |
            | o   | offline                                | /^[^o]+$/  |
            | r   | rm                                     | /^[^r]+$/  |
            | s   | selfupdate                             | /^[^s]+$/  |
            | u   | u, ug, uninstall, update, upgrade, use | /^[^u]+$/  |
            | un  | uninstall                              |            |
            | up  | update, upgrade                        |            |
            | us  | use                                    |            |
            | v   | v, version                             | /^[^v]+$/  |
            # Currently uncovered (except by fuzzy matches);
            # include negatives to prevent accidents:
            | a   |                                        | /^a/       |
            | g   |                                        | /^g/       |
            | j   |                                        | /^j/       |
            | k   |                                        | /^k/       |
            | m   |                                        | /^m/       |
            | n   |                                        | /^n/       |
            | p   |                                        | /^p/       |
            | q   |                                        | /^q/       |
            | t   |                                        | /^t/       |
            | w   |                                        | /^w/       |
            | x   |                                        | /^x/       |
            | y   |                                        | /^y/       |
            | z   |                                        | /^z/       |

    Scenario Outline: Completion for 'install'
        When the user enters "install <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd                     | completions    | exclusions  |
            | an                      | ant            | gradle      |
            | xyz                     |                | /.*/        |
            | 1.                      |                | /.*/        |
            | gra                     | gradle, grails | ant         |
            | grad                    | gradle         | ant, grails |
            | gradk                   |                | /.*/        |
#            | ant 1.10.                 | 1.10.0, 1.10.1    | |  # TODO: list installable versions --> issue #4
            | ant 1.10.2-mine /tm     | /tmp/          | /bin        |
            | 'ant 1.10.2-mine /tmp ' |                | /.*/        |
        # NB: Excluding wildcard pattern /.*/ expresses "do not offer any completions"

    Scenario Outline: Completion for 'uninstall'
        When the user enters "uninstall <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd           | completions   | exclusions    |
            |               | ant, crash    | gradle        |
            | a             | ant           | gradle        |
            | j             |               | /.*/          |
            | 1.            |               | /.*/          |
            | an            | ant           | gradle, crash | # some installed
            | gr            |               | /.*/          | # none installed
            | xyz           |               | /.*/          | # no such candidate
            | 'an '         |               | /.*/          | # no such candidate installed
            | 'ant 1'       | 1.10.1, 1.9.9 | /^\w+$/       |
            | 'ant 1.10.'   | 1.10.1        | 1.9.9         |
            | 'ant 2'       |               | /.*/          |
            | 'ant 1.10.1 ' |               | /.*/          | # only one version at a time

    Scenario Outline: Completion for 'list'
        When the user enters "list <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd    | completions | exclusions |
            | an     | ant         | crash      |
            | xyz    |             | /.*/       |
            | 1.     |             | /.*/       |
            | 'ant ' |             | /.*/       |

    Scenario Outline: Completion for 'use'
        When the user enters "use <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd           | completions   | exclusions    |
            |               | ant, crash    | gradle        |
            | an            | ant           | crash, gradle |
            | j             |               | /.*/          |
            | 1.            |               | /.*/          |
            | 'ant '        | 1.10.1, 1.9.9 | /^\w+$/       |
            | 'ant 1.10.1 ' |               | /.*/          |

    Scenario Outline: Completion for 'default'
        When the user enters "default <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd           | completions   | exclusions    |
            |               | ant, crash    | gradle        |
            | an            | ant           | crash, gradle |
            | j             |               | /.*/          |
            | 1.            |               | /.*/          |
            | 'ant '        | 1.10.1, 1.9.9 | /^\w+$/       |
            | 'ant 1.10.1 ' |               | /.*/          |

    Scenario Outline: Completion for 'home'
        When the user enters "home <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd           | completions   | exclusions    |
            |               | ant, crash    | gradle        |
            | an            | ant           | crash, gradle |
            | j             |               | /.*/          |
            | 1.            |               | /.*/          |
            | 'ant '        | 1.10.1, 1.9.9 | /^\w+$/       |
            | 'ant 1.10.1 ' |               | /.*/          |

    Scenario Outline: Completion for 'env'
        When the user enters "env <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd           | completions             | exclusions                      |
            |               | init, install, clear    | /^(?!init\|install\|clear).*$/  |
            | i             | init, install           | /^(?!init\|install).*$/         |
            | ini           | init                    | /^(?!init).*$/                  |
            | ins           | install                 | /^(?!install).*$/               |
            | c             | clear                   | /^(?!clear).*$/                 |
            | a             |                         | /.*/                            |
            | 'init '       |                         | /.*/                            |
            | 'clear '      |                         | /.*/                            |
            | 'install '    |                         | /.*/                            |

    Scenario Outline: Completion for 'current'
        When the user enters "current <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd    | completions | exclusions |
            | an     | ant         | gradle     | # --> installed version
            | gr     | gradle      | ant        | # --> not installed
            | xyz    |             | /.*/       |
            | 1.     |             | /.*/       |
            | 'ant ' |             | /.*/       |

    Scenario Outline: Completion for 'upgrade'
        When the user enters "upgrade <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd    | completions | exclusions    |
            |        | ant, crash  | gradle        |
            | an     | ant         | crash, gradle |
            | j      |             | /.*/          |
            | 1.     |             | /.*/          |
            | 'ant ' |             | /^\w+$/       |

    Scenario Outline: Completion for 'offline'
        When the user enters "offline <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd       | completions     | exclusions                |
            |           | disable, enable | /^(?!disable\|enable).*$/ | # NB: \| escaped to get it past Gherkin's parser
            | en        | enable          | /^(?!enable).*$/          |
            | di        | disable         | /^(?!disable).*$/         |
            | an        |                 | /.*/                      |
            | 'enable ' |                 | /.*/                      |

    Scenario Outline: Completion for 'selfupdate'
        When the user enters "selfupdate <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd      | completions | exclusions      |
            |          | force       | /^(?!force).*$/ |
            | f        | force       | /^(?!force).*$/ |
            | a        |             | /.*/            |
            | 'force ' |             | /.*/            |

    Scenario Outline: Completion for 'flush'
        When the user enters "flush <cmd>" into the prompt
        Then completion should propose "<completions>"
        But  completion should not propose <exclusions>
        Examples:
            | cmd     | completions                       | exclusions                                  |
            |         | archives, broadcast, tmp, version | /^(?!archives\|broadcast\|tmp\|version).*$/ |
            | b       | broadcast                         | /^(?!broadcast).*$/                         |
            | a       | archives                          | /^(?!archives\|broadcast).*$/               |
            | t       | tmp                               | /^(?!tmp\|broadcast).*$/                    |
            | v       | version                           | /^(?!version\|archives).*$/                 |
            | x       |                                   | /.*/                                        |
            | 'tmp '  |                                   | /.*/                                        |

    Scenario Outline: Completion for commands without parameters
        When the user enters "<cmd>" into the prompt
        Then completion should not propose /.*/
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
