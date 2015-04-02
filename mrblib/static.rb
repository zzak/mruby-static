module Static
  class Configuration
    attr_accessor :site_name, :pid, :host, :port, :root, :output, :css

    def initialize(options={})
      @site_name = "Static HTML Site"
      @pid = nil
      @host = "0.0.0.0"
      @port = "8000"
      @root = "./"
      @output = "output/"
      @css = "static.css"
    end
  end

  def self.configure(options={}, &block)
    self.configuration ||= Configuration.new(options)
    yield(configuration) if block_given?
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
      @document.body = "Your content here."
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
          @server.response_body = Site.documents[route].to_html
          @server.create_response
        end
      end

      @server.location("/index.html") do |res|
        @server.set_response_headers "Content-type" => "text/html; charset=utf-8"
        @server.response_body = Site.homepage
        @server.create_response
      end

      @server.location("/static.css") do |res|
        @server.response_body = Site.css
        @server.create_response
      end
    end
  end

  class Template
    def initialize
      @renderer = Discount.new(
        Static.configuration.css, Static.configuration.site_name)
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
    attr_accessor :css, :documents, :homepage, :routes

    def self.homepage
      @homepage ||= begin
        doc = Document.new
        doc.body = documents.map do |url, _|
          url.gsub!(".md", ".html")
          "[#{url}](#{url})"
        end.join("")
        doc.to_html
      end
    end

    def self.css
      @css ||= File.read(
        File.join(Static.configuration.root, Static.configuration.css)
      )
    end

    def self.routes
      @routes ||= Dir.entries(Static.configuration.root).select do |file|
        file =~ /.+.md/
      end
    end

    def self.documents
      @documents ||= routes.inject({}) do |hash, route|
        hash[route] = Document.new
        path = File.join(Static.configuration.root, route)
        hash[route].body = File.read(path)
        hash
      end
    end
  end

  class Generate
    def site
      Dir.mkdir(Static.configuration.output) unless
        Dir.exist?(Static.configuration.output)

      generate_homepage
      generate_posts
      generate_assets
    end

    def generate_homepage
      path = File.join(Static.configuration.output, "index.html")
      File.open(path, 'w+') { |file| file.write(Site.homepage) }
    end

    def generate_posts
      Site.documents.each do |key, value|
        path = File.join(Static.configuration.output, key).gsub('.md', '.html')

        File.open(path, 'w+') do |file|
         file.write value.to_html
        end
      end
    end

    def generate_assets
      path = File.join(Static.configuration.output, "/static.css")
      File.open(path, 'w+') { |file| file.write(Site.css) }
    end
  end

  class Document
    attr_accessor :title, :body

    def initialize
      @template = Template.new
    end

    def to_html
      "" << @template.render do
        body.to_html
      end
    end

    def save!
      path = File.join(Static.configuration.root, @title.gsub(' ', '_'))
      File.open("#{path}.md", 'w+') do |file|
        file.write body
      end
    end
  end
end
