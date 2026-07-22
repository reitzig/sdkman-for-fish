Feature: Support autoenv setting
    When the user sets `sdkman_auto_env=true`, we should always `use` the
    candidates specified in `./.sdkmanrc`, if any.

    Background:
        Given candidate ant is installed at version 1.9.7
        And   candidate ant is installed at version 1.9.9
        And   candidate ant is installed at version 1.10.1
        And   candidate kscript is installed at version 1.5.0
        And   candidate kscript is installed at version 1.6.0

    Scenario: No action after cd if autoenv turned off
        Given SDKMAN! config sets sdkman_auto_env to false
        And   file /tmp/autoenv-test/.sdkmanrc exists with content
            """
            ant=1.9.9
            """
        When we run fish script
            """
            echo (basename (realpath $ANT_HOME)) > /tmp/autoenv-test.log
            cd /tmp/autoenv-test
            echo (basename (realpath $ANT_HOME)) >> /tmp/autoenv-test.log
            cd ..
            echo (basename (realpath $ANT_HOME)) >> /tmp/autoenv-test.log
            """
        Then file /tmp/autoenv-test.log contains
            """
            1.10.1
            1.10.1
            1.10.1
            """

    Scenario: No action after starting fish if autoenv turned off
        Given SDKMAN! config sets sdkman_auto_env to false
        And   file .sdkmanrc exists with content
            """
            ant=1.9.9
            """
        When we run fish script
            """
            echo (basename (realpath $ANT_HOME)) > /tmp/autoenv-test.log
            """
        Then file /tmp/autoenv-test.log contains
            """
            1.10.1
            """

    Scenario: .sdkmanrc loaded after cd if autoenv turned on
        Given SDKMAN! config sets sdkman_auto_env to true
        And   file /tmp/autoenv-test/.sdkmanrc exists with content
            """
            ant=1.9.9
            """
        And   file .sdkmanrc does not exist
        When we run fish script
            """
            echo (basename (realpath $ANT_HOME)) > /tmp/autoenv-test.log
            cd /tmp/autoenv-test
            echo (basename (realpath $ANT_HOME)) >> /tmp/autoenv-test.log
            cd ..
            echo (basename (realpath $ANT_HOME)) >> /tmp/autoenv-test.log
            """
        Then file /tmp/autoenv-test.log contains
            """
            1.10.1
            1.9.9
            1.10.1
            """

    Scenario: .sdkmanrc loaded after starting fish if autoenv turned on
        Given SDKMAN! config sets sdkman_auto_env to true
        And   file .sdkmanrc exists with content
            """
            ant=1.9.9
            """
        When we run fish script
            """
            echo (basename (realpath $ANT_HOME)) > /tmp/autoenv-test.log
            """
        Then file /tmp/autoenv-test.log contains
            """
            1.9.9
            """

    # TODO: But that PR had been merged back when -- re-investigate
    @pending # This one doesn't work due to a bug in sdkman. Track: https://github.com/sdkman/sdkman-cli/pull/878
    Scenario: Switching between directories with .sdkmanrc
        Given SDKMAN! config sets sdkman_auto_env to true
        And   file /tmp/autoenv-test-1/.sdkmanrc exists with content
            """
            ant=1.9.9
            kscript=1.5.0
            """
        And   file /tmp/autoenv-test-2/.sdkmanrc exists with content
            """
            ant=1.9.7
            """
        When we run fish script
            """
            echo (basename (realpath $ANT_HOME)),(basename (realpath $KSCRIPT_HOME)) > /tmp/autoenv-test.log
            cd /tmp/autoenv-test-1
            echo (basename (realpath $ANT_HOME)),(basename (realpath $KSCRIPT_HOME)) >> /tmp/autoenv-test.log
            cd ../autoenv-test-2
            echo (basename (realpath $ANT_HOME)),(basename (realpath $KSCRIPT_HOME)) >> /tmp/autoenv-test.log
            cd ..
            echo (basename (realpath $ANT_HOME)),(basename (realpath $KSCRIPT_HOME)) >> /tmp/autoenv-test.log
            """
        Then file /tmp/autoenv-test.log contains
            """
            1.10.1,1.6.0
            1.9.9,1.5.0
            1.9.7,1.6.0
            1.10.1,1.6.0
            """
