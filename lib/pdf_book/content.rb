require "fastimage"

module PDFBook::Content
  
  class Text

    attr_accessor :data

    def initialize(text)
      @data = text
    end
  end

  class ColumnText

    attr_accessor :data

    def initialize(*texts)
      @data = []
      texts.each do |text|
        @data << text
      end
    end
  end

  class Image

    attr_accessor :data, :width, :height

    # Require a png image (some 'png' block the script)
    def initialize(path)
      raise "Image not found at '#{path}'" if !File.exist?(path)
      @type = FastImage.type(path)
      raise "Image must be a JPG (#{@type})" if ![:jpg, :jpeg].include? @type
      @data = path
      @width, @height = FastImage.size(path, raise_on_failure: true, timeout: 2)
      @mode = (@width > @height) ? :landscape : :portrait
      @ratio = @width / @height
    end
  end
end