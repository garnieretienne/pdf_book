require 'prawn'
require 'open-uri'

class PDFBook::Document

  attr_accessor :sections, :index, :extras, :toc
  attr_reader :page_width, :page_height, :margin_options, :pdf, :last_position, :index_pages

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
    @index = {}
    @extras = {}
    @page_number = []

    # Watermark
    @watermark ||= options[:watermark]

    build_document
  end

  # Add custom font families to the document
  def font_families=(font_families)
    @font_families = font_families
    update_font_families
  end

  def <<(section)
    self.sections << section
  end

  def table_of_content_options(options={})
    @toc_template = options[:template] || PDFBook::Section.new
    @toc_position = options[:position] || @pdf.bounds.top
    @toc_width    = options[:width]    || @pdf.bounds.width
    @toc_start_at = options[:start_at] || 1
  end

  def index_options(options={})
    @index_template = options[:template] || PDFBook::Section.new
    @index_position = options[:position] || @pdf.bounds.top
    @index_width    = options[:width]    || @pdf.bounds.width
    @index_start_at = options[:start_at] || 1
  end

  def pages
    page_count = 0

    # If the document is not rendered yet
    if @pdf.page_count == 0
      sandbox do
        render
        page_count = @pdf.page_count
      end
    else
      page_count = @pdf.page_count
    end

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

  def render
    
    # if @note_page
    #   render_note_page
    #   @pdf.start_new_page
    # end

    sections.each do |section|
      case section
      when :table_of_content
        @toc_page = @pdf.page_count
      when :index
        @index_page = @pdf.page_count
      else
        raise TypeError, "#{section.class} is not PDFBook::Section" if section.class != PDFBook::Section
        render_section section
      end
    end

    render_table_of_content if @toc_page
    render_index if @index_page

    #@index?
    @pdf.number_pages "<page>",
      at: [0, -20],
      align: :center,
      page_filter: @page_number,
      start_count_at: (!@page_number.empty? && @toc_start_at) ? @page_number.first-@toc_start_at+1 : 1

    return true
  end

  private

  # Initialize the PDF
  def build_document
    @pdf = Prawn::Document.new(
      page_size: @page_size,
      skip_page_creation: true
    )

    # Add custom font families if exist
    update_font_families

    # Watermark
    if @watermark
      @pdf.create_stamp("watermark") do
        @pdf.fill_color "D2D2D2"
        @pdf.text_box @watermark,
          :size   => 2.cm,
          :width  => @pdf.bounds.width,
          :height => @pdf.bounds.height,
          :align  => :center,
          :valign => :center,
          :at     => [0, @pdf.bounds.height],
          :rotate => 45,
          :rotate_around => :center
      end
    end
  end

  def update_font_families
    @pdf.font_families.update @font_families if @font_families
  end

  # Work in a sandbox (nothing will affect the real document).
  def sandbox(&block)

    # Backup current state
    backup = {}
    backup[:pdf]            = @pdf
    backup[:index_template] = @index_template
    backup[:toc_template]   = @toc_template
    
    # Recreate a new temporary PDF to work with
    build_document
    @index_template = PDFBook::Section.new
    @toc_template   = PDFBook::Section.new
    block.call

    # Restore old state
    @pdf            = backup[:pdf]
    @index_template = backup[:index_template]
    @toc_template   = backup[:toc_template]
  end

  def init_new_page(new_margin_options={})
    @pdf.start_new_page @margin_options.merge(new_margin_options)
    @pdf.font(@font)
    @pdf.stamp "watermark" if @watermark
  end

  def render_index

    # Increment page number if the ToC page will be insered before the index page
    @index_page += 1 if !@toc_page.nil? && @toc_page < @index_page

    # If no ToC page has been set (= the book will not have a ToC), set it to 0 to not modify page number after
    @toc_page = 0 if !@toc_page
    index_options if !@index_template
  
    # Build a Hash of topic and associed subtopics ordered by page numbers
    ordered = {} 
    @toc.each{ |label, page| ordered["#{label}"] = {page: page, subtopics: {}, extras: {}}}
    last_ordered_topic_key = ordered.keys.last
    @index.each do |label, page|
      last_topic = {label: ordered.first[0], page: ordered.first[1][:page]}
      ordered.each do |topic_label, topic_attributes|
        if page > last_topic[:page] && page < topic_attributes[:page]
          ordered["#{last_topic[:label]}"][:subtopics]["#{label}"] = {page: page}
        elsif page > last_topic[:page] && topic_label == last_ordered_topic_key
          ordered["#{last_ordered_topic_key}"][:subtopics]["#{label}"] = {page: page}
        end
        last_topic = {label: topic_label, page: topic_attributes[:page]}
      end
    end
    @extras.each do |label, page|
      last_topic = {label: ordered.first[0], page: ordered.first[1][:page]}
      ordered.each do |topic_label, topic_attributes|
        if page > last_topic[:page] && page < topic_attributes[:page]
          ordered["#{last_topic[:label]}"][:extras]["#{label}"] = {page: page}
        elsif page > last_topic[:page] && topic_label == last_ordered_topic_key
          ordered["#{last_ordered_topic_key}"][:extras]["#{label}"] = {page: page}
        end
        last_topic = {label: topic_label, page: topic_attributes[:page]}
      end
    end

    # Order topics by names and display them
    topic_size=9
    subtopic_size = 9
    @index_template.add_custom move_cursor_to: @index_position
    ordered.sort_by{|label, attributes| label}.each do |label, parameters|

      # Index page is insered at the end and can modify registered page numbers
      parameters[:page] = (@index_page < parameters[:page]) ? parameters[:page] + 1 : parameters[:page]

      # Toc page is insered at the end and can modify registered page numbers
      parameters[:page] = (@toc_page < parameters[:page]) ? parameters[:page] + 1 : parameters[:page]

      # 'Start at' modificateur
      parameters[:page] = parameters[:page] - @index_start_at + 1

      # Display topic
      @index_template.add_custom move_down: 10
      line_width = @pdf.bounds.width - @pdf.width_of("#{label},    #{parameters[:page]}", size: topic_size, style: :bold)-10
      @index_template.add_custom(
        text: [ 
          "#{label},    #{parameters[:page]}", 
          size: topic_size,
          style: :bold
        ],
        move_up: 4,
        horizontal_line: [@pdf.width_of("#{label},    #{parameters[:page]}", size: topic_size)+10, line_width],
        move_down: 10
      )

      # Order subtopics by name and display them
      parameters[:subtopics].sort_by{|subtopic_label, subtopic_parameters| subtopic_label}.each do |subtopic_label, subtopic_parameters|
        
        # Index page is insered at the end and can modify registered page numbers
        subtopic_parameters[:page] = (@index_page < subtopic_parameters[:page]) ? subtopic_parameters[:page] + 1 : subtopic_parameters[:page]

        # Toc page is insered at the end and can modify registered page numbers
        subtopic_parameters[:page] = (@toc_page < subtopic_parameters[:page]) ? subtopic_parameters[:page] + 1 : subtopic_parameters[:page]

        # 'Start at' modificateur
        subtopic_parameters[:page] = subtopic_parameters[:page] - @index_start_at + 1

        # Display subtopic
        @index_template.add_custom(
          text: [ 
            "#{subtopic_label},  #{subtopic_parameters[:page]}", 
          size: subtopic_size
          ]
        )
      end

      @index_template.add_custom move_down: 8

      # Order extras by name amd display them
      parameters[:extras].sort_by{|extra_label, extra_parameters| extra_label}.each do |extra_label, extra_parameters|
        
        # Index page is insered at the end and can modify registered page numbers
        extra_parameters[:page] = (@index_page < extra_parameters[:page]) ? extra_parameters[:page] + 1 : extra_parameters[:page]

        # Toc page is insered at the end and can modify registered page numbers
        extra_parameters[:page] = (@toc_page < extra_parameters[:page]) ? extra_parameters[:page] + 1 : extra_parameters[:page]

        # 'Start at' modificateur
        extra_parameters[:page] = extra_parameters[:page] - @index_start_at + 1

        # Display extra
        @index_template.add_custom(
          text: [ 
            "#{extra_label},  #{extra_parameters[:page]}", 
          size: subtopic_size
          ]
        )
      end
    end
 
    @pdf.go_to_page @index_page if @index_page > 0

    # Render and record the number of index pages
    page_number_before = @pdf.page_count
    render_section @index_template
    @index_pages = @pdf.page_count - page_number_before
  end

  def render_table_of_content
    table_of_content_options if !@toc_template
    cells = []
    @toc.sort_by{|label, page| page}.each do |label, page|

      # The 'Index' page is insered at the end
      if @index_page
        page = (@index_page < page) ? page + 1 : page
      end

      # The 'Table of Content' page is insered at the end
      page = (@toc_page < page) ? page + 1 : page

      # 'Start at' parameter
      page = page - @toc_start_at + 1

      label_cell = @pdf.make_cell(content: label.to_s)
      page_cell = @pdf.make_cell(content: page.to_s)
      page_cell.align = :right
      cells << [label_cell, page_cell]
    end
    if !cells.empty?
      @toc_template.add_custom(
        move_cursor_to: @toc_position,
        table: [
          cells,
          width: @toc_width,
          cell_style: { borders: []},
          position: :center
        ]
      )
    end
    @pdf.go_to_page @toc_page if @toc_page > 0
    render_section @toc_template
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

    if section.toc
      @toc[section.toc] = @pdf.page_count
    end

    if section.index
      @index[section.index] = @pdf.page_count
    end

    if section.extra
      @extras[section.extra] = @pdf.page_count
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
        @pdf.font content.font || @font do
          @pdf.move_cursor_to content.position if content.position
          @pdf.text content.data, 
            align: content.align, 
            size: content.font_size, 
            style: content.font_style, 
            leading: content.line_height,
            color: content.color
          @pdf.move_down content.gap if content.gap
        end

      when PDFBook::Content::ColumnText
        @pdf.table [content.data], 
          width: @pdf.bounds.width, 
          cell_style: { borders: [], size: content.font_size, leading: content.line_height, padding: 0}
        @pdf.move_down content.gap if content.gap

      when PDFBook::Content::Image
        @pdf.move_cursor_to content.position if content.position
        max_width = content.max_width || @pdf.bounds.width
        max_height = content.max_height || @pdf.bounds.height-(@pdf.bounds.height-@pdf.cursor)
        image_origin = [(@pdf.bounds.width-max_width)/2, @pdf.cursor]
        if content.width > max_width || content.height > max_height
          @pdf.image(open(content.data), fit: [max_width, max_height], position: :center)
        else
          @pdf.image(open(content.data), position: :center)
        end
        if content.mark_image_area
          @pdf.line_width(2)
          @pdf.stroke_rectangle(image_origin, max_width, max_height)
          @pdf.line_width(1)
        end
        @pdf.move_down content.gap if content.gap

      else
        raise TypeError, "This content (#{content.class}) is not allowed"
      end

      record_last_position
    end

    if section.page_number
      page_number = @pdf.page_number
      if @toc_page
        page_number += 1 if @pdf.page_number > @toc_page 
      end
      if @index_page
        page_number += 1 if @pdf.page_number > @index_page 
      end
      @page_number << page_number
    end
  end

  # Record the last know cursor position in the last page with content
  def record_last_position
    @last_position = @pdf.cursor
  end
end