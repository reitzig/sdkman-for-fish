# SDKMAN! for fish

[![Build Status][travis-badge]][travis-link]

Makes command `sdk` from [SDKMAN!] usable from [fish], including auto-completion.
Also adds binaries from installed SDKs to the PATH.

Version 1.4.0 tested with 

 - fish 2.7.1 and 3.1.2, and 
 - SDKMAN! 5.8.2, on
 - Ubuntu 18.04 LTS and macOS 10.13

## Install

With [fisher] (install separately):

```
fisher add reitzig/sdkman-for-fish@v1.4.0
```

_Note:_ 

 - Only compatible with fisher v3 upwards; v2 is no longer supported.
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
