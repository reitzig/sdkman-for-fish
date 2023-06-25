# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - upcoming

### Breaking

- Drop (explicit) support for Fish 2

### Features

- Compatibility with SDKMAN! 5.18.2
  - Completions for `env`, `home`, `flush` (issue #35)
  - Correct behaviour of `env clear`. 
  - Honor `sdkman_auto_env=true` (issue #38)
  - `broadcast` removed
  - TODO: custom SDKMAN! install path (issue #34)
- Compatibility with fisher 4 (PR #37, #39)

## [1.4.0] - 2019-11-06

### Features

- Compatibility with macOS (issue #29)

## [1.3.0] - 2019-11-05

### Features

- Install SDKMAN! if missing (issue #26)

## [1.2.0] - 2019-07-31

### Features

- Compatibility with fish 3 (issue #27)

## [1.1.2] - 2019-01-06

### Fixes

-  Re-initialize if user has changed (issue #25)

## [1.1.1] - 2018-11-09

### Fixes

- Set `_HOME` environment variables (issue #24)

## [1.1.0] - 2018-10-08

### Features

- Compatibility with fisher 3 (PR #22)

## [1.0.0] - 2018-07-21

Initial release. 
