require 'pdf_book/content'

class PDFBook::Section

  attr_accessor :layout, :contents

  def initialize(options={})
    @layout = options[:layout] || :plain
    @contents = []
  end

  def add_text(text)
    @contents << PDFBook::Content::Text.new(text)
    return self
  end

  # Return the max line number occuped by the text contents
  def max_lines
    row_number = 0
    contents.each do |content|
      if content.class == PDFBook::Content::Text
        row_number = content.text.lines.count
      else
        row_number = 1
      end
    end
    return row_number
  end
end