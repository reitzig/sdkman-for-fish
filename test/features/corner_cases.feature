Feature: Corner Cases

    Scenario: sdk not initialized in this shell
        Given environment variable SDKMAN_DIR is not set
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    Scenario: sdk initialized for another user in this shell
        # Use any directory outside of the user's home directory
        Given environment variable SDKMAN_DIR is set to "/"
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    Scenario: Custom installation path
        Given SDKMAN! is installed at /tmp/sdkman
        And   fish config file config_sdk.fish exists with content
            """
            set -g __sdkman_custom_dir /tmp/sdkman
            """
        When  we run "sdk version" in Fish
        Then  the exit code is 0
        And   the output contains "SDKMAN!"
        And   environment variable SDKMAN_DIR has value "/tmp/sdkman"
        And   environment variable ANT_HOME has value "/tmp/sdkman/candidates/ant/current"

    Scenario Outline: Completions with custom installation path
        Given SDKMAN! is installed at /tmp/sdkman
        And   fish config file config_sdk.fish exists with content
            """
            set -g __sdkman_custom_dir /tmp/sdkman
            """
        When the user enters "<cmd>" into the prompt
        Then completion should propose "<completions>"
        Examples:
            | cmd             | completions   |
            | install an      | ant           |
            | uninstall an    | ant           |
            | uninstall ant 1 | 1.10.1, 1.9.9 |
            | list an         | ant           |
            | use an          | ant           |
            | use ant 1       | 1.10.1, 1.9.9 |
            | default an      | ant           |
            | default ant 1   | 1.10.1, 1.9.9 |
            | home an         | ant           |
            | home ant 1      | 1.10.1, 1.9.9 |
            | current an      | ant           |
            | upgrade an      | ant           |

    @pending # cf. issue #10
    Scenario: PATH should contain only valid paths
        Given candidate kscript is installed
        When  candidate kscript is uninstalled
        Then  environment variable PATH cannot contain "sdkman/candidates/kscript/"

    # TODO: add test that fails if `test` in conf.d/sdk.fish:80 errors (cf issue #28 et al.)
