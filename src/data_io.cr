require "json"
require "yaml"
require "./data_format"

module Json2Yaml
  class DataIO
    @pretty : Bool
    @indent : String

    def initialize(@pretty, indent : UInt8)
      if indent == 0
        @pretty = false
      end
      @indent = " " * indent
    end

    def read(io : IO, data_format : DataFormat)
      case data_format
      when DataFormat::Json
        JSON.parse(io)
      when DataFormat::Yaml
        YAML.parse(io)
      else
        raise InvalidDataFormat.new(data_format)
      end
    end

    def write(io : IO, data_format : DataFormat, data)
      case data_format
      when DataFormat::Json
        if @pretty
          data.to_pretty_json(io, @indent)
        else
          data.to_json(io)
        end
        io.puts # JSON needs extra newline
      when DataFormat::Yaml
        YAML.dump(data, io) # YAML includes newline
      else
        raise InvalidDataFormat.new(data_format)
      end
    end
  end
end
