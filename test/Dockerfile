FROM ubuntu@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
# hadolint ignore=DL3008,DL3028
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
        build-essential \
        curl \
        fish \
        nano \
        ruby \
        ruby-dev \
        tree \
        unzip \
        zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && gem install bundler

WORKDIR /tmp
COPY test/Gemfile ./
RUN bundle install \
 && rm Gemfile

# Switch to non-root user for test context
ARG TEST_HOME="/home/test"
RUN groupadd -r test \
 && useradd --no-log-init -r -g test -m -d $TEST_HOME test
USER test
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
WORKDIR "${TEST_HOME}/sdk4fish_test"
COPY --chown=test:test test ./
ENTRYPOINT ["cucumber"]
CMD ["--publish-quiet", "--tags", "not @pending"]
