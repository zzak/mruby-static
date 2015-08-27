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

1. Download the source: `git clone https://github.com/zzak/mruby-static`

2. Build inside docker with `docker-compose run compile`

3. Install binary to your PATH (i.e.: `mruby/build/<ARCH>/bin/mruby-static`)

4. Create a `site.rb` file (See below).

5. Generate a post: `mruby-static post:new "The Title Of My Post"`

6. Preview your site: `mruby-static preview:run`

## site.rb

This file is used to initialize Static and issue commands. For example:

```ruby
Static.configure do |config|
  config.site_name = "mruby-static"
  config.root = "src/"
  config.asset_dir = "assets/"
  config.template_dir = "templates/"
end
```

Please see `Static::Configuration` class for more config options.

## License

mruby-static is released under the [MIT License](http://www.opensource.org/licenses/MIT).
