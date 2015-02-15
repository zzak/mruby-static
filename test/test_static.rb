assert('Static::Template') do
  template = Static::Template.new
  template.to_html === "<html><head><title>ZOMG</title></head><body><h1>phew</h1></body></html>"
  template.to_html === ""
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

assert('configure using block') do
  Static.configure do
  end

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
