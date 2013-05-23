require 'prawn'

class PDFBook::Document

  attr_accessor :sections 
  attr_reader :page_width, :page_height

  def initialize(options={})
    @note_page ||= options[:note_page]

    # Page size
    @page_size = options[:page_size] || 'LETTER'
    if @page_size.class == String
      @page_width = Prawn::Document::PageGeometry::SIZES[@page_size][0].to_f
      @page_height = Prawn::Document::PageGeometry::SIZES[@page_size][1].to_f
    else
      @page_width = @page_size[0].to_f
      @page_height = @page_size[1].to_f
    end

    # Page margins
    @margin_options = {
      top_margin: options[:page_margin_top] || 0.5,
      bottom_margin: options[:page_margin_bottom] || 0.5,
      left_margin: options[:page_margin_left] || 0.5,
      right_margin: options[:page_margin_right] || 0.5
    }

    # Fonts
    @font = options[:font] || 'Times-Roman'
    
    # Book content
    @sections = []

    # Initialize the PDF
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

  def init_new_page(new_margin_options={})
    @pdf.start_new_page @margin_options.merge(new_margin_options)
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
    init_new_page(section.margin_options)

    if section.background
      case section.background_size
      when :fullpage
        @pdf.image section.background,
          at: [-@pdf.bounds.absolute_left, @page_height - @pdf.bounds.absolute_bottom],
          width: @page_width,
          height: @page_height
      when :margin
        @pdf.image section.background,
          width: @pdf.bounds.width,
          height: @pdf.bounds.height
      end
    end
    
    if section.title
      @pdf.text section.title, size: 20, align: :center
      @pdf.move_down 40
    end

    section.contents.each do |content|
      case content

      when PDFBook::Content::Custom
        content.data.each do |command, args|
          @pdf.stroke do 
            @pdf.send command, *args
          end
        end

      when PDFBook::Content::Chapter
        @pdf.move_down 40
        @pdf.text content.data, size: 30, align: :center
        @pdf.move_down 60

      when PDFBook::Content::Text
        @pdf.move_cursor_to content.position if content.position
        @pdf.text content.data, 
          align: content.align, 
          size: content.font_size, 
          style: content.font_style, 
          leading: content.line_height, 
          color: content.color
        @pdf.move_down content.font_size+content.line_height

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
    end
  end
end