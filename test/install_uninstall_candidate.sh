#!/usr/bin/env bash

    source "${HOME}/.sdkman/bin/sdkman-init.sh" \
&&  sdk install crash 1.3.0 \
&&  sdk uninstall crash 1.3.0
