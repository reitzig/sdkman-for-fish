# SDKMAN! for fish

[![license](https://img.shields.io/github/license/reitzig/sdkman-for-fish.svg)](https://github.com/reitzig/sdkman-for-fish/blob/master/LICENSE)
[![release](https://img.shields.io/github/release/reitzig/sdkman-for-fish.svg)](https://github.com/reitzig/sdkman-for-fish/releases/latest)
[![GitHub release date](https://img.shields.io/github/release-date/reitzig/sdkman-for-fish.svg)](https://github.com/reitzig/sdkman-for-fish/releases)
![Tests](https://github.com/reitzig/sdkman-for-fish/workflows/Tests/badge.svg?branch=master)

Makes command `sdk` from [SDKMAN!] usable from [fish], including auto-completion.
Also adds binaries from installed SDKs to the PATH.

Version 2.0.0 has been tested with 

 - fish 3.1.2, and 
 - SDKMAN! 5.11.0, on
 - Ubuntu 20.04 LTS and macOS 10.15

## Install

With [fisher] (install separately):

```
fisher add reitzig/sdkman-for-fish@v2.0.0
```

_Note:_ 

 - Only compatible with fisher v4 upwards; v3 is no longer supported.
 - You have to install [SDKMAN!] separately.

## Usage

It's all in the background; you should be able to run `sdk` and binaries installed
with `sdk` as you would expect.

## Contribute

When you make changes, 
please run the tests at least on one platform before creating a pull request.

As the tests may mess up your own setup
-- you have been warned! -- 
the recommended way is to run the tests in a Docker container:
 
```fish
docker build -t sdkman-for-fish-tests -f test/Dockerfile .
docker run --rm sdkman-for-fish-tests
```
   
A run configuration for Jetbrains IDEs is included.

It is a also possible to run individual features, for instance:

```fish
docker run --rm sdkman-for-fish-tests features/completions.feature
```

As a corollary, this is the fastest way to run all tests 
(if you do not care about the report):

```fish
for f in features/*.feature
  docker run --rm sdkman-for-fish-tests "$f" &
done
wait
```

## Acknowledgements

 * Completion originally by [Ted Wise](https://github.com/ctwise); see his
     [blog post from 2016](http://tedwise.com/2016/02/26/using-sdkman-with-the-fish-shell).
 * Binary loading originally by [Koala Yeung](https://github.com/yookoala);
     see [his comment on sdkman/sdkman-cli#294](https://github.com/sdkman/sdkman-cli/issues/294#issuecomment-318252058).
 * While this is predominantly a personal project,
   the initial migration to Cucumber tests was done as spike on
     [20% time](https://en.wikipedia.org/wiki/20%25_Project) 
   graciously provided by 
     [codecentric](https://codecentric.de).
   Thank you!

[SDKMAN!]: https://github.com/sdkman/sdkman-cli
[fish]: https://fishshell.com/
[fisher]: https://github.com/jorgebucaran/fisher
[travis-link]: https://travis-ci.org/reitzig/sdkman-for-fish
[travis-badge]: https://travis-ci.org/reitzig/sdkman-for-fish.svg?branch=master
