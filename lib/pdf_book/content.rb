require 'fastimage'
require 'open-uri'

module PDFBook::Content

  # Custom Prawn content
  class Custom
    attr_accessor :data

    def initialize(commands)
      @data = commands
    end
  end
  
  # Text content
  class Text

    attr_accessor :data, :position, :align, :font_size, :font_style, :line_height, :color, :gap, :font

    def initialize(text, options={})
      @data = text
      @position ||= options[:position]
      @align = options[:align] || :left
      @font_size = options[:font_size] || 12
      @font_style = options[:font_style] || :normal
      @line_height = options[:line_height] || 0
      @color = options[:color] || "000000"
      @gap ||= options[:gap]
      @font ||= options[:font]
    end
  end

  # Text content in two column
  class ColumnText

    attr_accessor :data, :font_size, :line_height, :gap

    def initialize(options={}, *texts)
      @data = []
      @font_size = options[:font_size] || 12
      @line_height = options[:line_height] || 0
      @gap ||= options[:gap]
      texts.each do |text|
        @data << text
      end
    end
  end

  # Image content
  class Image

    attr_accessor :data, :width, :height, :max_width, :max_height, :position, :gap, :mark_image_area

    # Require a png image (some 'png' block the script)
    def initialize(path, options={})
      @type = FastImage.type(path)
      
      @data = path
      @width, @height = FastImage.size(path, raise_on_failure: true, timeout: 5)
      @mode = (@width > @height) ? :landscape : :portrait
      @ratio = @width / @height

      @position ||= options[:position]
      @max_width ||= options[:max_width]
      @max_height ||= options[:max_height]
      @gap ||= options[:gap]
      @mark_image_area ||= options[:mark_image_area]
    end
  end
end