require "fastimage"

module PDFBook::Content

  class Chapter

    attr_accessor :data

    def initialize(title)
      @data = title
    end
  end

  class Custom
    attr_accessor :data

    def initialize(commands)
      @data = commands
    end
  end
  
  class Text

    attr_accessor :data, :position, :align, :font_size, :font_style, :line_height, :color

    #  :bold, :italic, :underline, :strikethrough, :subscript, and :superscript
    # Font::AFM::BUILT_INS: ["Courier", "Helvetica", "Times-Roman", "Symbol", "ZapfDingbats", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique", "Times-Bold", "Times-Italic", "Times-BoldItalic", "Helvetica-Bold", "Helvetica-Oblique", "Helvetica-BoldOblique"]
    def initialize(text, options={})
      @data = text
      @position ||= options[:position]
      @align = options[:align] || :left
      @font_size = options[:font_size] || 12
      @font_style = options[:font_style] || :normal
      @line_height = options[:line_height] || 12
      @color = options[:color] || "000000"
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

    attr_accessor :data, :width, :height, :max_width, :max_height, :position

    # Require a png image (some 'png' block the script)
    def initialize(path, options={})
      raise "Image not found at '#{path}'" if !File.exist?(path)
      @type = FastImage.type(path)
      raise "Image must be a JPG (#{@type})" if ![:jpg, :jpeg].include? @type
      
      @data = path
      @width, @height = FastImage.size(path, raise_on_failure: true, timeout: 2)
      @mode = (@width > @height) ? :landscape : :portrait
      @ratio = @width / @height

      @position ||= options[:position]
      @max_width ||= options[:max_width]
      @max_height ||= options[:max_height]
    end
  end
end