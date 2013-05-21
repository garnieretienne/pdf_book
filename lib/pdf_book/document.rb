require 'prawn'

class PDFBook::Document

  attr_accessor :sections

  def initialize(options={})
    @pdf = Prawn::Document.new
    @sections = []
  end

  def to_pdf(path)
    render
    @pdf.render_file path
  end

  private

  def render
    sections.each do |section|
      raise TypeError, "#{section.class} is not PDFBook::Section" if section.class != PDFBook::Section
      @pdf.start_new_page
      render_section section
    end
  end

  def render_section(section)
    @pdf.text section.title
    @pdf.move_down 40
    section.contents.each do |content|
      case content
      when PDFBook::Content::Text
        @pdf.text content.data
      when PDFBook::Content::ColumnText
        @pdf.table([content.data], width: @pdf.bounds.width, cell_style: { borders: []})
      when PDFBook::Content::Image
        height_available = @pdf.bounds.height-(@pdf.bounds.height-@pdf.cursor)
        if content.width > @pdf.bounds.width || content.height > height_available
          @pdf.image(content.data, fit: [@pdf.bounds.width, height_available], position: :center)
        else
          @pdf.image(content.data, position: :center)
        end

      else
        raise TypeError, "This content (#{content.class}) is not allowed"
      end
      @pdf.move_down 20
    end
  end
end