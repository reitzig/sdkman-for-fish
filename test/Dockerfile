FROM ubuntu

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

WORKDIR app
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
ARG shared_test_setup="false"
ENV SHARED_TEST_SETUP=$shared_test_setup
SHELL ["/bin/bash", "-c"]
RUN if [ "${shared_test_setup}" = 'true' ]; then \
         source "$TEST_HOME/.sdkman/bin/sdkman-init.sh" \
      && sdk update \
      && sdk install ant 1.9.7 \
      && sdk install ant 1.9.9 \
      && sdk install ant 1.10.1 \
      && sdk install kscript 1.5.0 \
      && sdk install kscript 1.6.0 \
      ; \
    fi

# "Install" sdkman-for-fish
RUN mkdir -p $TEST_HOME/.config/fish/
COPY --chown=test:test completions $TEST_HOME/.config/fish/completions/
COPY --chown=test:test conf.d      $TEST_HOME/.config/fish/conf.d/
COPY --chown=test:test functions   $TEST_HOME/.config/fish/functions/
RUN ls -R $TEST_HOME/.config/fish/

# Run tests
COPY test ./
ENTRYPOINT ["cucumber"]
CMD ["--publish-quiet", "--tags", "not @pending"]
