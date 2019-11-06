#!/usr/bin/env bash

    rm -rf "${HOME}/.sdkman" \
&&  sed -i'.bak' -E -e 's/^.*(sdkman|SDKMAN).*$//g' "${HOME}/.bashrc" \
&&  echo 'SDKMAN! uninstalled'
