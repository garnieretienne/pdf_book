require 'pdf_book/content'

class PDFBook::Section

  attr_accessor :title, :background, :background_size, :contents, :margin_options, :index, :page_number

  def initialize(options={})
    @title ||= options[:title]
    @background ||= options[:background]
    @background_size = options[:background_size] || :fullpage
    @contents = []
    @index = (options[:index])
    @page_number = options[:page_number] || false

    # Overrride page options
    @margin_options = {}
    @margin_options[:top_margin] = options[:page_margin_top] if options[:page_margin_top]
    @margin_options[:bottom_margin] = options[:page_margin_bottom] if options[:page_margin_bottom]
    @margin_options[:left_margin] = options[:page_margin_left] if options[:page_margin_left]
    @margin_options[:right_margin] = options[:page_margin_right] if options[:page_margin_right]
  end

  def add_custom(*args)
    @contents << PDFBook::Content::Custom.new(*args)
    return self
  end

  def add_chapter(*args)
    @contents << PDFBook::Content::Chapter.new(*args)
    return self
  end

  def add_text(*args)
    @contents << PDFBook::Content::Text.new(*args)
    return self
  end

  def add_column_text(*args)
    @contents << PDFBook::Content::ColumnText.new(*args)
    return self
  end

  def add_image(*args)
    @contents << PDFBook::Content::Image.new(*args)
    return self
  end
end