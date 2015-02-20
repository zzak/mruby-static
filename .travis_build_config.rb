MRuby::Build.new do |conf|
  toolchain :gcc
  enable_debug

  conf.gembox 'default'

  conf.gem :github => 'iij/mruby-io'
  #conf.gem :github => 'iij/mruby-dir'
  conf.gem :github => 'iij/mruby-pack'
  conf.gem :github => 'iij/mruby-socket'

  conf.gem :github => 'matsumoto-r/mruby-discount'
  conf.gem :github => 'mattn/mruby-http'
  conf.gem :github => 'mattn/mruby-onig-regexp'
  conf.gem :github => 'matsumoto-r/mruby-simplehttpserver'

  # be sure to include this gem
  conf.gem File.expand_path(File.dirname(__FILE__))
end
