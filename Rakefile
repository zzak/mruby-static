STATIC_ROOT=ENV["STATIC_ROOT"] || Dir.pwd
MRUBY_ROOT=ENV["MRUBY_ROOT"] || "#{STATIC_ROOT}/mruby"
MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"]) || "#{STATIC_ROOT}/build_config.rb"
INSTALL_PREFIX=ENV["INSTALL_PREFIX"] || "#{STATIC_ROOT}/build"
MRUBY_VERSION=ENV["MRUBY_VERSION"] || "1.1.0"

file :mruby do # :nodoc:
  `wget https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz`
  `tar -xvzf #{MRUBY_VERSION}.tar.gz && rm #{MRUBY_VERSION}.tar.gz`
  `mv mruby-#{MRUBY_VERSION} mruby`
end

desc "compile binary"
task :compile => :mruby do
  `cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all`
  `cp -p #{MRUBY_ROOT}/bin/mruby #{STATIC_ROOT}/bin/static`
end

desc "test"
task :test => :compile do
  system "cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all test"
end

desc "install"
task :install => :compile do
  `mkdir -p #{INSTALL_PREFIX}/bin`
  `cp -p #{STATIC_ROOT}/bin/static #{INSTALL_PREFIX}/bin/.`
end

desc "cleanup"
task :clean do
  `rm #{STATIC_ROOT}/bin/static`
  `cd #{MRUBY_ROOT} && ruby minirake deep_clean`
end

task :default => :test
