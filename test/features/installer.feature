Feature: Install SDKMAN! if necessary

    Scenario:
        Given SDKMAN! is not installed
        When  sdk is called and user answers "n"
        Then  SDKMAN! is absent

    Scenario:
        Given SDKMAN! is not installed
        When  sdk is called and user answers "y"
        Then  SDKMAN! is present
