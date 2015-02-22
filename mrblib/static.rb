module Static
  class Configuration
    attr_accessor :site_name, :pid, :host, :port, :root

    def initialize(options={})
      @site_name = "Static HTML Site"
      @pid = nil
      @host = "0.0.0.0"
      @port = "8000"
      @root = "./"
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
    yield(configuration)
  end

  def self.start
    begin
      parse_command!
    rescue ArgumentError
      help!
    end
  end

  class Post
    def new
      raise NotImplementedError
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
    def locations
      @routes ||= Dir.entries(Static.configuration.root).select do |file|
        file =~ /.+.md/
      end
    end

    def build!
      locations.each do |file|
        define_location(file) do
          path = File.expand_path(Static.configuration.root + file)
          File.read(path)
        end
      end

      @server.location("/static.css") do |res|
        @server.response_body = File.read("public/static.css")
        @server.create_response
      end
    end

    def define_location file, &block
      @server.location "/#{file}" do |res|
        document = Document.new
        document.body = yield
        @server.response_body = document.to_html
        @server.create_response
      end
    end
  end

  class Template
    def initialize *args
      @renderer = Discount.new(*args)
    end

    def render &block
      output = ""
      output << @renderer.header
      output << yield
      output << @renderer.footer
    end
  end

  # TODO: generation
  class Generator
    def self.generate
      document = Document.new
      document.author = "zzak"
      document.publish_date = Date.new
      document.title = "My First Post"
      document.body = "This is the content"

      document.to_html
    end
  end

  class Document
    attr_accessor :author, :publish_date, :title, :body

    def initialize
      @publish_date = Time.now
      @template = Template.new(
        "/static.css",
        Static.configuration.site_name
      )
    end

    def to_html
      "" << @template.render do
        body.to_html
      end
    end
  end
end
