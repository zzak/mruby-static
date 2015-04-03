# Static HTML Site Generator

[![Build Status](https://travis-ci.org/zzak/mruby-static.svg)](https://travis-ci.org/zzak/mruby-static)

A simple, static, HTML site generator inspired by Jekyll.

## Features

* Statically compiled
* Write content in markdown
* Built-in web server for previews
* TODO:Templates written in ERB
* Easily generating pages and posts

## Getting Started

1. Download the source: `git clone git://github.com/zzak/mruby-static.git`

2. Install it with `rake`

3. Create a `site.rb` file (See below).

4. Generate a post: `bin/static site.rb post:new "The Title Of My Post"`

5. Preview your site: `bin/static site.rb preview:run`

## site.rb

This file is used to initialize Static and issue commands. For example:

```ruby
Static.configure do |config|
  config.site_name = "mruby-static"
  config.root = "src/"
end

Static.start
```

Any configuration here that is allowed, but the import thing to remember:
You MUST call `Static.start`, or the CLI won't interpret any commands.

Please see `Static::Configuration` class for more options.

## License

mruby-static is released under the [MIT License](http://www.opensource.org/licenses/MIT).
