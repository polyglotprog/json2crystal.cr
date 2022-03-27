require "./data_format"
require "./data_io"

module Json2Yaml
  abstract class DataConverter
    abstract def convert
  end

  class InputConverter < DataConverter
    @io : DataIO
    @input_format : DataFormat
    @output_format : DataFormat

    def initialize(@io, @input_format)
      @output_format = @input_format.other
    end

    # Read from STDIN, write to STDOUT
    def convert
      data = @io.read(STDIN, @input_format)
      @io.write(STDOUT, @output_format, data)
    end
  end

  class FileArrayConverter < DataConverter
    @io : DataIO
    @output_dir : String
    @files : Array(String)
    @loud : Bool

    def initialize(@io, @output_dir, @files, @loud = true)
      validate
    end

    # Convert list of files
    def convert
      @files.each do |input_file|
        convert_file(input_file)
      end
    end

    def convert_file(input_file : String)
      dirname = File.dirname(input_file) # TODO?
      input_extname = File.extname(input_file)
      input_format = DataFormat.parse_extension(input_extname)
      basename = File.basename(input_file, input_extname)
      output_format = input_format.other
      output_extname = output_format.extname
      output_file = "#{@output_dir}/#{basename}#{output_extname}"

      data = @io.read(File.new(input_file), input_format)
      @io.write(File.new(output_file, "w"), output_format, data)
      if @loud
        STDERR.puts "+ Converting #{input_file} -> #{output_file}"
      end
    end

    private def validate
      validate_output_dir(@output_dir)
      @files.each do |file|
        if !File.exists?(file)
          raise ArgumentError.new("File does not exist: #{file}")
        end
        if File.directory?(file)
          raise ArgumentError.new("File is a directory: #{file}")
        end
        extname = File.extname(file)
        if extname != ".json" && extname != ".yaml"
          raise ArgumentError.new("File has invalid extension: #{file}")
        end
      end
    end

    private def validate_output_dir(output_dir : String)
      if !Dir.exists?(output_dir)
        raise ArgumentError.new(
          "Output directory does not exist: #{output_dir}"
        )
      end
    end
  end
end
