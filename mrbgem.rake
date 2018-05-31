MRuby::Gem::Specification.new('mruby-static') do |spec|
  spec.license = 'MIT'
  spec.author  = 'zzak'
  spec.summary = 'Static HTML Site Generator'
  spec.bins = ["mruby-static"]

  spec.add_dependency 'mruby-io', :core => 'mruby-io'
  spec.add_dependency 'mruby-dir', :mgem => 'mruby-dir'
  spec.add_dependency 'mruby-eval', :core => 'mruby-eval'
  spec.add_dependency 'mruby-string-ext', core: 'mruby-string-ext'
  spec.add_dependency 'mruby-markdown', :github => 'KeizoBookman/mruby-markdown', :branch => 'update_latest'
  spec.add_dependency 'mruby-simplehttpserver', :mgem => 'mruby-simplehttpserver'
end
