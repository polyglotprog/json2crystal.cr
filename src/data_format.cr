module Json2Yaml
  enum DataFormat
    Json
    Yaml

    def extname
      ".#{self.to_s.downcase}"
    end

    def other
      case self
      when Json
        return Yaml
      when Yaml
        Json
      else
        raise InvalidDataFormat.new(self)
      end
    end

    def self.parse_extension(extension : String)
      parse(extension.byte_slice(1))
    end
  end

  class InvalidDataFormat < Exception
    getter data_format

    def initialize(@data_format : DataFormat)
    end
  end
end
