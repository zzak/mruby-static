module Static
  class Configuration
    attr_accessor :site_name, :pid, :host, :port, :root, :output

    def initialize(options={})
      @site_name = "Static HTML Site"
      @pid = nil
      @host = "0.0.0.0"
      @port = "8000"
      @root = "./"
      @output = "output/"
    end
  end

  class << self
    attr_accessor :configuration

    private
    def parse_command!
      command = ARGV.shift
      if command =~ /\w+:\w+/
        klass, action = command.split(":")
      else
        raise "unknown command."
      end

      Static.const_get(klass.capitalize).new.send(action)
    end
  end

  def self.help!
    puts <<-EOS
mruby-static:
  preview, preview:run to preview your site
  post:new to create a new post
    EOS
  end

  def self.configure(options={}, &block)
    self.configuration ||= Configuration.new(options)
    yield(configuration) if block_given?
  end

  def self.start
    begin
      parse_command!
    rescue ArgumentError
      help!
    end
  end

  class Post
    attr_accessor :document

    def new
      @document = Document.new
      @document.author = "Your name here."
      @document.body = "Your content here."
      @document.publish_date = Time.now
      @document.title = ARGV.shift

      @document.save!
    end
  end

  class Preview
    def initialize
      url = "#{Static.configuration.host}:#{Static.configuration.port}"
      puts "Starting preview at #{url}"

      @server = SimpleHttpServer.new({
        :server_ip => Static.configuration.host,
        :port  => Static.configuration.port,
        :document_root => Static.configuration.root,
      })

      build!
    end

    def run
      @server.run
    end

    private
    def build!
      Site.routes.each do |route|
        @server.location "/#{route}" do |res|
          document = Document.new
          path = File.expand_path(Static.configuration.root + route)
          document.body = File.read(path)
          @server.response_body = document.to_html
          @server.create_response
        end
      end

      @server.location("/static.css") do |res|
        @server.response_body = File.read("public/static.css")
        @server.create_response
      end
    end
  end

  class Template
    def initialize(css_path="static.css", title="Static HTML Site Generator")
      @renderer = ::Discount.new(css_path, title)
    end

    def render &block
      output = []
      output << @renderer.header
      output << yield if block_given?
      output << @renderer.footer
      output.join("")
    end
  end

  class Site
    attr_accessor :routes

    def self.routes
      @routes ||= Dir.entries(Static.configuration.root).select do |file|
        file =~ /.+.md/
      end
    end
  end

  class Generate
    def site
      Dir.mkdir(Static.configuration.output)

      generate_posts
      generate_assets
    end

    def generate_posts
      Site.routes.each do |route|
        document = Document.new
        path = File.expand_path(Static.configuration.root + route)
        document.body = File.read(path)

        output = File.expand_path(Static.configuration.output + route)
        File.open(output.gsub('.md', '.html'), 'w+') do |file|
          file.write document.to_html
        end
      end
    end

    def generate_assets
      css = File.read File.expand_path(Static.configuration.root + "static.css")
      path = File.expand_path(Static.configuration.output + "static.css")

      File.open(path, 'w+') do |file|
        file.write css
      end
    end
  end

  class Document
    attr_accessor :author, :publish_date, :title, :body, :path, :filename

    def initialize
      @publish_date = Time.now
      @template = Template.new(
        "static.css",
        Static.configuration.site_name
      )
    end

    def to_html
      "" << @template.render do
        body.to_html
      end
    end

    def path
      @path ||= File.expand_path(Static.configuration.root + filename)
    end

    def filename
      @filename ||= @title.gsub(' ', '_')
    end

    def save!
      File.open("#{path}.md", 'w+') do |file|
        file.write body
      end
    end
  end
end
