require 'prawn'

class PDFBook::Document

  attr_accessor :sections

  def initialize(options={})
    @note_page ||= options[:note_page]

    @page_size = options[:page_size] || 'LETTER'
    
    if @page_size.class == String
      @page_width = Prawn::Document::PageGeometry::SIZES[@page_size][0]
      @page_height = Prawn::Document::PageGeometry::SIZES[@page_size][1]
    else
      @page_width = @page_size[0]
      @page_height = @page_size[1]
    end

    @font = options[:font] || 'Times-Roman'
    @sections = []

    @pdf = Prawn::Document.new(
      page_size: @page_size,
      skip_page_creation: true
    )
  end

  def to_pdf
    render
    @pdf.render
  end

  def to_file(path)
    render
    @pdf.render_file path
  end

  private

  def init_new_page
    @pdf.start_new_page
    @pdf.font(@font)
  end

  def render
    
    if @note_page
      render_note_page
      @pdf.start_new_page
    end

    sections.each do |section|
      raise TypeError, "#{section.class} is not PDFBook::Section" if section.class != PDFBook::Section
      render_section section
    end

    @pdf
  end

  def render_note_page
    @pdf.move_down 40
    @pdf.text 'Notes', size: 20, align: :center
    @pdf.move_down 60
    7.times do
      @pdf.stroke_horizontal_rule
      @pdf.move_down 60
    end
    @pdf.move_down 20
  end

  def render_section(section)
    init_new_page
    if section.background
      @pdf.image section.background,
        at: [-@pdf.bounds.absolute_left, @page_height - @pdf.bounds.absolute_bottom],
        width: @page_width,
        height: @page_height
    end
    
    if section.title
      @pdf.text section.title, size: 20, align: :center
      @pdf.move_down 40
    end

    section.contents.each do |content|
      case content

      when PDFBook::Content::Chapter
        @pdf.move_down 40
        @pdf.text content.data, size: 30, align: :center
        @pdf.move_down 60

      when PDFBook::Content::Text
        @pdf.move_cursor_to content.position if content.position
        @pdf.text content.data, align: content.align, size: content.font_size, style: content.font_style

      when PDFBook::Content::ColumnText
        @pdf.table([content.data], width: @pdf.bounds.width, cell_style: { borders: []})

      when PDFBook::Content::Image
        @pdf.move_cursor_to content.position if content.position
        max_width = content.max_width || @pdf.bounds.width
        max_height = content.max_height || @pdf.bounds.height-(@pdf.bounds.height-@pdf.cursor)
        if content.width > max_width || content.height > max_height
          @pdf.image(content.data, fit: [max_width, max_height], position: :center)
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