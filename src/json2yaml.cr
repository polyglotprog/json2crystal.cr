require "./data_converter"
require "./data_format"
require "./data_io"
require "./options"

module Json2Yaml
  class Json2Yaml
    def run
      options = Options.parse
      begin
        converter = create_converter(options)
        converter.convert
      rescue ex : Exception
        if options.loud
          STDERR.puts ex.message
          exit(1)
        end
      end
    end

    private def create_converter(options : Options) : DataConverter
      files = options.files
      output_dir = options.output_dir
      io = DataIO.new(options.pretty, options.indent)

      if files.empty?
        input_format = DataFormat.parse(options.input_format)
        InputConverter.new(io, input_format)
      else
        FileArrayConverter.new(io, output_dir, files, options.loud)
      end
    end
  end
end

Json2Yaml::Json2Yaml.new.run
