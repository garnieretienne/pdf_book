require 'pdf_book/content'

class PDFBook::Section

  attr_accessor :title, :background, :contents

  def initialize(options={})
    @title ||= options[:title]
    @background ||= options[:background]
    @contents = []
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