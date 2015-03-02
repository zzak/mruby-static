assert('Static::Template') do
  Static.configure

  template = Static::Template.new
  body = "<h1>phew</h1>"

  template.render { body } === <<-EOS
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<title>Static HTML Site</title>
<link rel="stylesheet" href="static.css" type="text/css" />
</head>
<body>
<h1>phew</h1>
</body>
</html>
EOS
end

assert('Static::Configuration') do
  config = Static::Configuration.new
  config.site_name === "Static HTML Site"
  config.pid === nil
  config.host === "0.0.0.0"
  config.port === "8000"
  config.root === "./"
end

assert('Modify Configuration using accessors') do
  config = Static::Configuration.new
  config.site_name = "OMG My HTML Site"
  config.pid = "/bar"
  config.host = "127.0.1.0"
  config.port = "8080"
  config.root = "/foo"

  config.site_name === "OMG My HTML Site"
  config.pid === "/bar"
  config.host === "127.0.1.0"
  config.port === "8080"
  config.root === "/foo"
end

assert('default configuration with block') do
  Static.configure do
  end

  Static.configuration.site_name === "Static HTML Site"
  Static.configuration.pid === nil
  Static.configuration.host === "0.0.0.0"
  Static.configuration.port === "8000"
  Static.configuration.root === "./"
end

assert('default configuration') do
  Static.configuration.site_name === "Static HTML Site"
  Static.configuration.pid === nil
  Static.configuration.host === "0.0.0.0"
  Static.configuration.port === "8000"
  Static.configuration.root === "./"
end

assert('default configuration without block') do
  Static.configure

  Static.configuration.site_name === "Static HTML Site"
  Static.configuration.pid === nil
  Static.configuration.host === "0.0.0.0"
  Static.configuration.port === "8000"
  Static.configuration.root === "./"
end

assert('configure using block and override') do
  Static.configure do |config|
    config.site_name = "OMG My HTML Site"
    config.pid = "/bar"
    config.host = "127.0.1.0"
    config.port = "8080"
    config.root = "/foo"
  end

  Static.configuration.site_name === "OMG My HTML Site"
  Static.configuration.pid === "/bar"
  Static.configuration.host === "127.0.1.0"
  Static.configuration.port === "8080"
  Static.configuration.root === "/foo"
end
