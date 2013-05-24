require 'prawn'

class PDFBook::Document

  attr_accessor :sections 
  attr_reader :page_width, :page_height, :margin_options

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
    @toc = {}
    @page_number = []

    # Initialize the PDF
    @pdf = Prawn::Document.new(
      page_size: @page_size,
      skip_page_creation: true
    )
  end

  def <<(section)
    self.sections << section
  end

  def table_of_content(options={})
    @toc_template = options[:template] || PDFBook::Section.new
    @toc_position = options[:position] || @pdf.bounds.top
    @toc_width    = options[:width]    || @pdf.bounds.width
    @toc_start_at = options[:start_at] || 1
  end

  def pages
    old_pdf = @pdf
    @pdf = Prawn::Document.new(
      page_size: @page_size,
      skip_page_creation: true
    )

    render
    page_count = @pdf.page_count
    
    @pdf = old_pdf
    return page_count
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

  def render_table_of_content
    cells = []
    @toc.each do |label, page|
      page = (@toc_page < page) ? page + 1 : page # the 'Table of Content' page is insered at the end
      page = page - @toc_start_at + 1
      label_cell = @pdf.make_cell(content: label.to_s)
      page_cell = @pdf.make_cell(content: page.to_s)
      page_cell.align = :right
      cells << [label_cell, page_cell]
    end
    @toc_template.add_custom(
      move_cursor_to: @toc_position,
      table: [
        cells,
        width: @toc_width,
        cell_style: { borders: []},
        position: :center
      ]
    )
    @pdf.go_to_page @toc_page
    render_section @toc_template
  end

  def render
    
    if @note_page
      render_note_page
      @pdf.start_new_page
    end

    sections.each do |section|
      case section
      when :table_of_content
        @toc_page = @pdf.page_count
      else
        raise TypeError, "#{section.class} is not PDFBook::Section" if section.class != PDFBook::Section
        render_section section
      end
    end

    render_table_of_content

    @pdf.number_pages "<page>",
      at: [0, -20],
      align: :center,
      page_filter: @page_number,
      start_count_at: (!@page_number.empty? && @toc_start_at) ? @page_number.first-@toc_start_at+1 : 1

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

    if section.index
      @toc[section.index] = @pdf.page_count
    end

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
        @pdf.move_cursor_to @pdf.bounds.height
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
            (args) ? @pdf.send(command, *args) : @pdf.send(command)
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
        @pdf.move_down content.gap if content.gap

      when PDFBook::Content::ColumnText
        @pdf.table [content.data], 
          width: @pdf.bounds.width, 
          cell_style: { borders: [], size: content.font_size, leading: content.line_height}
        @pdf.move_down content.gap if content.gap

      when PDFBook::Content::Image
        @pdf.move_cursor_to content.position if content.position
        max_width = content.max_width || @pdf.bounds.width
        max_height = content.max_height || @pdf.bounds.height-(@pdf.bounds.height-@pdf.cursor)
        if content.width > max_width || content.height > max_height
          @pdf.image(content.data, fit: [max_width, max_height], position: :center)
        else
          @pdf.image(content.data, position: :center)
        end
        @pdf.move_down content.gap if content.gap

      else
        raise TypeError, "This content (#{content.class}) is not allowed"
      end
    end

    if section.page_number
      @page_number << @pdf.page_count
    end
  end
end