Feature: Corner Cases

    Scenario: sdk not initialized in this shell
        Given environment variable SDKMAN_DIR is not set
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    Scenario: sdk initialized for another user in this shell
        Given environment variable SDKMAN_DIR is set to "/"
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    # TODO: add test that fails if `test` in conf.d/sdk.fish:80 errors (cf issue #28 et al.)

    Scenario: PATH should contain only valid paths
        Given candidate crash is installed
        When  candidate crash is uninstalled
        Then  environment variable PATH cannot contain "sdkman/candidates/crash/"
