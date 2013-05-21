require 'prawn'

class PDFBook::Document

  attr_accessor :parts

  def initialize(options={})
    @pdf = Prawn::Document.new
    @parts = []
  end

  def to_pdf(path)
    render
    @pdf.render_file path
  end

  private

  # TODO: column layout
  # TODO: raise Type error if section is not the right class
  def render
    parts.each do |part|
      @pdf.start_new_page
      part.sections.each do |section|
        render_section section
      end
    end
  end

  # TODO: raise an exeption if the content is not know
  def render_section(section)
    if section.layout == :column
      table_data = [ section.contents.map {|content| content.text if content.class == PDFBook::Content::Text} ]
      # debugger
      @pdf.table(table_data, width: @pdf.bounds.width, cell_style: { borders: []})
      @pdf.move_down 20
    else
      section.contents.each do |content|
        case content
        when PDFBook::Content::Text
          @pdf.text content.text
          @pdf.move_down 20
        end
      end
    end
  end
end