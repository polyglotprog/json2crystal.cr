require "option_parser"

module Json2Yaml
  struct Options
    property files : Array(String)
    property indent : UInt8
    property input_format : String
    property output_dir : String
    property ugly : Bool
    property silent : Bool

    def initialize
      # Default values
      @files = Array(String).new
      @indent = 2
      @input_format = "json"
      @output_dir = "."
      @ugly = true
      @silent = false
    end

    def loud
      !@silent
    end

    def pretty
      !@ugly
    end

    def self.parse : self
      options = Options.new
      OptionParser.parse do |parser|
        # Banner
        parser.banner = "Usage: json2yaml [OPTION]... [FILE]..."
        # -h, --help
        parser.on(
          "-h", "--help",
          "Show this help"
        ) do
          puts parser
          exit
        end
        # -i, --indent
        parser.on(
          "-i INDENT", "--indent INDENT",
          "Number of spaces to indent for JSON"
        ) do |indent|
          options.indent = indent.to_u8
        end
        # -j, --json
        parser.on(
          "-j", "--json",
          "Set input format to JSON (stdin only)"
        ) do
          options.input_format = "json"
        end
        # -o, --output
        parser.on(
          "-o DIR", "--output DIR",
          "Output directory"
        ) do |output_dir|
          options.output_dir = output_dir
        end
        # -u, --ugly
        parser.on(
          "-u", "--ugly",
          "Turn off pretty printing (JSON only)"
        ) do
          options.ugly = true
        end
        # -s, --silent
        parser.on(
          "-s", "--silent",
          "Silent (no output)"
        ) do
          options.silent = true
        end
        # -y, --yaml
        parser.on(
          "-y", "--yaml",
          "Set input format to YAML (stdin only)"
        ) do
          options.input_format = "yaml"
        end
        # Invalid option
        parser.invalid_option do |option|
          if options.loud
            STDERR.puts "#{option} is not a valid option."
            STDERR.puts parser
          end
          exit(1)
        end
        # Missing option
        parser.missing_option do |option|
          if options.loud
            STDERR.puts "#{option} is missing a value."
            STDERR.puts parser
          end
          exit(1)
        end
        # Unknown args
        parser.unknown_args do |args|
          if !args.empty?
            options.files = args
          end
        end
      end
      options
    end
  end
end
