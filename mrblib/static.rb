module Static
  class FileMissing < StandardError; end
  class PathMissing < StandardError; end

  class Configuration
    attr_accessor :site_name, :pid, :host, :port, :root, :output, :css, :template_dir, :asset_dir

    def initialize(options={})
      @site_name = "Static HTML Site"
      @pid = nil
      @host = "0.0.0.0"
      @port = "8000"
      @root = "./"
      @output = "output/"
      @template_dir = "templates/"
      @asset_dir = "assets/"
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
    def parse_command!(argv)
      command = argv.shift
      if command =~ /\w+:\w+/
        klass, action = command.split(":")
      else
        raise ArgumentError, "unknown command."
      end

      Static.const_get(klass.capitalize).new.send(action, *argv)
    end

    def read_config!
      raise FileMissing, "site.rb" unless File.exists?("site.rb")
      eval File.read("site.rb")
    end

    def check_paths!
      raise PathMissing, "template_dir" unless Dir.exist?(Static.configuration.template_dir)
      raise PathMissing, "asset_dir" unless Dir.exist?(Static.configuration.asset_dir)
      raise PathMissing, "root dir" unless Dir.exist?(Static.configuration.root)
    end
  end

  def self.help!
    puts <<-EOS
mruby-static:
  generate:site to compile your site
  preview:run to preview your site
  post:new to create a new post
    EOS
  end

  def self.start(argv)
    read_config!
    check_paths!

    begin
      parse_command!(argv)
    rescue ArgumentError
      help!
    end
  end

  class Post
    attr_accessor :document

    def new(*args)
      @document = Document.new
      @document.body = "Your content here."
      @document.title = args.shift

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
          @server.set_response_headers "Content-type" => "text/html; charset=utf-8"
          @server.response_body = Site.documents[route].to_html
          @server.create_response
        end
      end

      @server.location("/#{Static.configuration.css}") do |res|
        @server.set_response_headers "Content-type" => "text/css"
        @server.response_body = Site.css
        @server.create_response
      end
    end
  end

  class Template
    def initialize
      @renderer = Markdown::Markdown.new
    end

    def render &block
      output = []
      output << Site.header
      output << @renderer.render(yield)
      output << Site.footer
      output.join("")
    end
  end

  class Site
    attr_accessor :css, :documents, :routes, :header, :footer

    def self.css
      _path = File.join(Static.configuration.asset_dir, Static.configuration.css)
      raise FileMissing, Static.configuration.css unless File.exists?(_path)
      @css ||= File.read(_path)
    end

    def self.header
      _path = File.join(Static.configuration.template_dir, "header.html")
      raise FileMissing, _path unless File.exists?(_path)
      @header ||= File.read(_path)
    end

    def self.footer
      _path = File.join(Static.configuration.template_dir, "footer.html")
      raise FileMissing, _path unless File.exists?(_path)
      @footer ||= File.read(_path)
    end

    def self.routes
      @routes ||= Dir.entries(Static.configuration.root).select do |file|
        file =~ /.+.md/
      end
    end

    def self.documents
      @documents ||= routes.inject({}) do |hash, route|
        hash[route] = Document.new
        _path = File.join(Static.configuration.root, route)
        raise FileMissing, _path unless File.exists?(_path)
        hash[route].body = File.read(_path)
        hash
      end
    end
  end

  class Generate
    def site
      Dir.mkdir(Static.configuration.output) unless
        Dir.exist?(Static.configuration.output)

      generate_posts
      generate_assets
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
        body
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

def __main__(argv)
  argv.shift # remove binary from args
  Static.start(argv)
end
