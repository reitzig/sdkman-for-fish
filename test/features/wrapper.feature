Feature: Wrapping of Bash
    All calls to sdk are performed through Bash;
    we need to wrap those calls in such a way that
    the effect sdk has on the Bash environment carries
    over the current Fish session.

    We verify equality of (standard) output, exit code, and environment variables.

    Background:
        Given SDKMAN! candidate list is up to date
        And   candidate ant is installed at version 1.9.9
        And   candidate ant is installed at version 1.10.1
        And   file /tmp/env-test/.sdkmanrc exists with content
            """
            ant=1.9.9
            """

    Scenario Outline:
        When we run "<command>" in Bash and Fish
        Then the exit code is the same
        And  the output is the same
        And  environment variable PATH is the same
        And  environment variables *_HOME are the same
        And  environment variables SDKMAN_* are the same except for SDKMAN_OFFLINE_MODE
             # NB: SDKMAN_OFFLINE_MODE is not an environment variable in bash, so ignore it here.
        Examples:
            | command                                             |
            | sdk                                                 |
            | sdk version                                         |
            | sdk list java                                       |
            | sdk update                                          |
            | sdk use ant 1.9.9                                   |
            | sdk offline enable > /dev/null; sdk install ant foo |
            | sdk use ant 1.9.9 > /dev/null; sdk broadcast        |
            | sdk home ant 1.9.9                                  |
            | cd /tmp/env-test; sdk env                           |
