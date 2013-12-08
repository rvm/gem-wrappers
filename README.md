# Gem wrappers

[![Gem Version](https://badge.fury.io/rb/gem-wrappers.png)](http://rubygems.org/gems/gem-wrappers)
[![Code Climate](https://codeclimate.com/github/rvm/gem-wrappers.png)](https://codeclimate.com/github/rvm/gem-wrappers)
[![Coverage Status](https://coveralls.io/repos/rvm/gem-wrappers/badge.png?branch=master)](https://coveralls.io/r/rvm/gem-wrappers?branch=master)
[![Build Status](https://travis-ci.org/rvm/gem-wrappers.png?branch=master)](https://travis-ci.org/rvm/gem-wrappers)
[![Dependency Status](https://gemnasium.com/rvm/gem-wrappers.png)](https://gemnasium.com/rvm/gem-wrappers)
[![Documentation](http://b.repl.ca/v1/yard-docs-blue.png)](http://rubydoc.info/gems/gem-wrappers/frames)

Create gem wrappers for easy use of gems in cron and other system locations.

## Configuration / Defaults

In `~/.gemrc` you can overwrite this defaults:

```ruby
wrappers_path: GEM_HOME/wrappers
wrappers_environment_file: GEM_HOME/environment
wrappers_path_take: 1
```

## Generating wrappers

By default wrappers are installed when a gem is installed,
to rerun the process for all gems in `GEM_HOME` use:

```bash
gem wrappers regenerate
```

## Showing current configuration

To see paths that are used by gem run:

```bash
gem wrappers
```
