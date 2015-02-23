STATIC_ROOT=ENV["STATIC_ROOT"] || Dir.pwd
MRUBY_ROOT=ENV["MRUBY_ROOT"] || "#{STATIC_ROOT}/mruby"
MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
INSTALL_PREFIX=ENV["INSTALL_PREFIX"] || "#{STATIC_ROOT}/build"
MRUBY_VERSION=ENV["MRUBY_VERSION"] || "1.1.0"

file :mruby do # :nodoc:
  sh "wget -q --no-check-certificate https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz"
  sh "tar -xvzf #{MRUBY_VERSION}.tar.gz"
  sh "rm #{MRUBY_VERSION}.tar.gz"
  sh "mv mruby-#{MRUBY_VERSION} mruby"
end

desc "compile binary"
task :compile => :mruby do
  sh "cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all"
  sh "cp -p #{MRUBY_ROOT}/bin/mruby #{STATIC_ROOT}/bin/static"
end

desc "test"
task :test => :mruby do
  sh "cd #{MRUBY_ROOT} && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all test"
end

desc "install"
task :install => :compile do
  sh "mkdir -p #{INSTALL_PREFIX}/bin"
  sh "cp -p #{STATIC_ROOT}/bin/static #{INSTALL_PREFIX}/bin/."
end

desc "cleanup"
task :clean do
  sh "rm #{STATIC_ROOT}/bin/static"
  sh "cd #{MRUBY_ROOT} && rake deep_clean"
end

task :default => :test
