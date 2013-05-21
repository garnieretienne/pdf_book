require 'pdf_book/content'

class PDFBook::Section

  attr_accessor :title, :contents

  def initialize(options={})
    @title ||= options[:title]
    @contents = []
  end

  def add_text(text)
    @contents << PDFBook::Content::Text.new(text)
    return self
  end

  def add_column_text(*texts)
    @contents << PDFBook::Content::ColumnText.new(*texts)
    return self
  end

  def add_image(path)
    @contents << PDFBook::Content::Image.new(path)
    return self
  end
end