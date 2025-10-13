FROM ubuntu@sha256:66460d557b25769b102175144d538d88219c077c678a49af4afca6fbfc1b5252

# Install dependencies
RUN apt-get update \
 && apt-get -y install \
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
