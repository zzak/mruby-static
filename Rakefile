STATIC_ROOT=ENV["STATIC_ROOT"] || Dir.pwd
MRUBY_ROOT=ENV["MRUBY_ROOT"] || "#{STATIC_ROOT}/mruby"
INSTALL_PREFIX=ENV["INSTALL_PREFIX"] || "#{STATIC_ROOT}/build"
MRUBY_VERSION=ENV["MRUBY_VERSION"] || "1.1.0"

file :mruby do # :nodoc:
  `wget https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz`
  `tar -xvzf #{MRUBY_VERSION}.tar.gz && rm #{MRUBY_VERSION}.tar.gz`
  `mv mruby-#{MRUBY_VERSION} mruby`
end

desc "compile binary"
task :compile => :mruby do
  `cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{STATIC_ROOT}/build_config.rb ruby minirake`
  `cp -p #{MRUBY_ROOT}/bin/mruby bin/static`
end

desc "test"
task :test => :compile do
  system "cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{STATIC_ROOT}/build_config.rb ruby minirake test"
end

desc "install"
task :install => :compile do
  `mkdir -p #{INSTALL_PREFIX}/bin`
  `cp #{STATIC_ROOT}/bin/static #{INSTALL_PREFIX}/bin/.`
end

desc "cleanup"
task :clean do
  `rm -rf #{STATIC_ROOT}/bin/static`
  `cd #{MRUBY_ROOT} && rake deep_clean`
end

task :default => :test
