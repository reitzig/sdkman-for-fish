FROM ubuntu:24.04

# TODO: pin fish version; renovate

# Install dependencies
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
        autoconf \
        build-essential \
        ca-certificates \
        curl \
        fish \
        libssl-dev \
        libyaml-dev \
        libffi-dev \
        libgmp-dev \
        rustc \
        unzip \
        zip \
        zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Switch to non-root user for test context
ARG TEST_HOME="/home/test"
RUN groupadd -r test \
 && useradd --no-log-init -r -g test -m -d $TEST_HOME test
USER test

WORKDIR "${TEST_HOME}"
COPY --chown=test:test mise.toml .config/mise/config.toml
ENV PATH="${TEST_HOME}/.local/share/mise/shims/:${TEST_HOME}/.local/bin/:${PATH}"
ENV MISE_RUBY_INSTALL=true
RUN curl --fail https://mise.run | sh \
 && mise install \
 && mise activate --shims \
 && gem install bundler

WORKDIR "${TEST_HOME}/sdk4fish_test"
COPY --chown=test:test test ./
RUN bundle install

# TODO: pin sdkman version, renovate (possible?)
RUN curl -s "https://get.sdkman.io" | bash

# To speed up tests, uncomment this shared setup:
SHELL ["/bin/bash", "-c"]
RUN source "$TEST_HOME/.sdkman/bin/sdkman-init.sh" \
 && sdk install ant 1.9.7 \
 && sdk install ant 1.9.9 \
 && sdk install ant 1.10.1 \
 && sdk install kscript 1.5.0 \
 && sdk install kscript 1.6.0

# "Install" sdkman-for-fish
RUN mkdir -p $TEST_HOME/.config/fish/
COPY --chown=test:test completions $TEST_HOME/.config/fish/completions/
COPY --chown=test:test conf.d      $TEST_HOME/.config/fish/conf.d/
COPY --chown=test:test functions   $TEST_HOME/.config/fish/functions/
RUN ls -R $TEST_HOME/.config/fish/

# Signal we're safely running in a container;
# we abort the tests to avoid breaking the host system!
ENV RUNNING_IN_CONTAINER=yessir

# Run tests
ENTRYPOINT ["cucumber"]
CMD ["--publish-quiet", "--tags", "not @pending"]
