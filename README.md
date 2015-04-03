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

2. Install it: `rake compile`

3. Generate a post: `bin/static site.rb post:new "The Title Of My Post"`

4. Preview your site: `bin/static site.rb preview:run`

## License

mruby-static is released under the [MIT License](http://www.opensource.org/licenses/MIT).
