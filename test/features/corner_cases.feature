Feature: Corner Cases

    Scenario: SDKMAN_DIR unset
        Given environment variable SDKMAN_DIR is not set
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    Scenario: SDKMAN_DIR set to a location the current user can't write at
        Given environment variable SDKMAN_DIR is set to "/"
        When  a new Fish shell is launched
        Then  environment variable SDKMAN_DIR has the original value

    # TODO: add test that fails if `test` in conf.d/sdk.fish:80 errors (cf issue #28 et al.)
