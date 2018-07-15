#!/usr/bin/env bash

source "${HOME}"/.sdkman/bin/sdkman-init.sh

# Set up an SDK with two installed versions
# --> test of `sdk use` in wrapper.fish 
# --> tests in completion.rb
sdk install ant 1.9.9
echo "y" | sdk install ant 1.10.1
sdk default ant 1.10.1