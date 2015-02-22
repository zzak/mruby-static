MRuby::Gem::Specification.new('mruby-static') do |spec|
  spec.license = 'MIT'
  spec.author  = 'zzak'
  spec.summary = 'Static HTML Site Generator'

  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-dir'
  spec.add_dependency 'mruby-discount'
  spec.add_dependency 'mruby-onig-regexp'
  spec.add_dependency 'mruby-simplehttpserver'
end
