require 'spec_helper'
require 'prawn/measurement_extensions'


describe PDFBook do
  before do
    @slim_image_path = "#{File.dirname(__FILE__)}/fixtures/files/slim.jpg"
    @large_image_path = "#{File.dirname(__FILE__)}/fixtures/files/large2.jpg"
    @highter_image_path = "#{File.dirname(__FILE__)}/fixtures/files/highter.jpg"
    @gray_divider_path = "#{File.dirname(__FILE__)}/fixtures/files/gray_divider.jpg"

    @cover_path = "#{File.dirname(__FILE__)}/fixtures/files/cover.jpg"
    @inner_cover_path = "#{File.dirname(__FILE__)}/fixtures/files/inner_cover.jpg"
    @toc_path = "#{File.dirname(__FILE__)}/fixtures/files/toc.jpg"
    @divider_path = "#{File.dirname(__FILE__)}/fixtures/files/divider.jpg"
  end

  # it 'should have a version number' do
  #   PDFBook::VERSION.should_not be_nil
  # end

  # it 'should create a new document' do
  #   PDFBook::Document.new
  # end

  # it 'should export a pdf' do
  #   book = PDFBook::Document.new
  #   book.to_pdf
  # end

  # it 'should create a new section' do
  #   section = PDFBook::Section.new(title: 'My Story')
  # end

  # it 'should create a new text content' do
  #   content = PDFBook::Content::Text.new "Hello World"
  #   content.data.should == "Hello World"
  # end

  # it 'should create a new column text content' do
  #   content = PDFBook::Content::ColumnText.new "Hello World", "Foo Bar"
  #   content.data.count.should == 2
  #   content.data.first.should == "Hello World"
  # end

  # it 'should create a new image content' do
  #   content = PDFBook::Content::Image.new @large_image_path
  #   content.data.should == @large_image_path
  #   content.width.should == 1035
  #   content.height.should == 1020
  # end

  # it 'should create a new chapter' do
  #   chapter = PDFBook::Content::Chapter.new 'Chapter 1'
  #   chapter.data.should == 'Chapter 1'
  # end

  # it 'should add text content to a section' do
  #   section = PDFBook::Section.new(title: 'Introduction')
  #   section.add_text "Hello World"
  #   section.contents.count.should == 1
  #   section.contents.first.class.should be PDFBook::Content::Text
  #   section.contents.first.data.should == "Hello World"
  # end

  # it 'should add a column text content to a section' do
  #   section = PDFBook::Section.new(title: 'List')
  #   section.add_column_text "Left side", "Right side"
  #   section.contents.count.should == 1
  #   section.contents.first.class.should be PDFBook::Content::ColumnText
  #   section.contents.first.data.last.should == "Right side"
  # end

  # it 'should add an image content to a section' do
  #   section = PDFBook::Section.new(title: 'Logo')
  #   section.add_image @slim_image_path
  #   section.contents.count.should == 1
  #   section.contents.first.class.should be PDFBook::Content::Image
  # end

  # it 'should add a section to a document' do
  #   doc = PDFBook::Document.new
  #   doc.sections << PDFBook::Section.new(title: 'Introduction')
  #   doc.sections.count.should == 1
  #   doc.sections.first.class.should be PDFBook::Section
  #   doc.sections.first.title.should == 'Introduction'
  # end

  # it 'should set a background image on every pages of the section' do
  #   doc = PDFBook::Document.new
  #   doc.sections << PDFBook::Section.new(background: @large_image_path)
  #   doc.sections.first.background.should == @large_image_path
  # end

  # it 'should create a cover' do

  #   book_size = [152.4.mm, 228.6.mm]

  #   book = PDFBook::Document.new(
  #     font: 'Times-Roman',
  #     page_size: book_size,
  #     page_margin_left: 19.05.mm,
  #     page_margin_right: 19.05.mm,
  #     page_margin_top: 15.mm,
  #     page_margin_bottom: 20.mm
  #   )

  #   cover_margin_bottom = 15.mm+2.mm # should add 2 more mm to be the same as old script 
  #   cover = PDFBook::Section.new(
  #     background: @cover_path,
  #     background_size: :margin,
  #     page_margin_left: 13.mm,
  #     page_margin_right: 13.mm,
  #     page_margin_top: 13.mm,
  #     page_margin_bottom: cover_margin_bottom
  #   )

  #   cover.add_image @large_image_path, 
  #     position: get_prawn_y(95.mm, book_size[1], cover_margin_bottom),
  #     max_width: 73.mm,
  #     max_height: 60.mm

  #   # Draw picture rectangle
  #   # use user image max height and width
  #   # x = (page_width - rectangle_width )/ 2-(margin_left + margin_right) /2
  #   cover.add_custom(
  #     line_width: 0.6.mm,
  #     rectangle: [ [(book.page_width-73.mm)/2-(13.mm+13.mm)/2, get_prawn_y(95.mm, book_size[1], cover_margin_bottom)], 73.mm, 60.mm ],
  #   )
    
  #   taglines = ["This is the best", "cookbook in the world"]
  #   cover.add_text taglines.join("\n"),
  #     position: get_prawn_y(175.mm, book_size[1], cover_margin_bottom),
  #     font_style: :italic,
  #     font_size: 13,
  #     align: :center, 
  #     line_height: 4.65,
  #     color: get_prawn_color("151,53,15")


  #   book.sections << cover
  #   book.to_file '/tmp/cover.pdf'
  # end

  # it "should build a blank page" do

  #   book = PDFBook::Document.new(
  #     font: 'Times-Roman',
  #     page_size: [152.4.mm, 228.6.mm],
  #     page_margin_left: 19.05.mm,
  #     page_margin_right: 19.05.mm,
  #     page_margin_top: 15.mm,
  #     page_margin_bottom: 20.mm
  #   )

  #   blank_page = PDFBook::Section.new

  #   book.sections << blank_page
  #   book.to_file '/tmp/blank.pdf'
  # end

  # it "should build an inner cover" do

  #   book_size = [152.4.mm, 228.6.mm]

  #   book = PDFBook::Document.new(
  #     font: 'Times-Roman',
  #     page_size: book_size,
  #     page_margin_left: 19.05.mm,
  #     page_margin_right: 19.05.mm,
  #     page_margin_top: 15.mm,
  #     page_margin_bottom: 20.mm
  #   )

  #   cover_margin_bottom = 15.mm+2.mm # should add 2 more mm to be the same as old script 
  #   inner_cover = PDFBook::Section.new(
  #     background: @inner_cover_path,
  #     background_size: :margin,
  #     page_margin_left: 13.mm,
  #     page_margin_right: 13.mm,
  #     page_margin_top: 13.mm,
  #     page_margin_bottom: cover_margin_bottom
  #   )

  #   taglines = ["This is the best", "cookbook in the world"]
  #   inner_cover.add_text taglines.join("\n"),
  #     position: get_prawn_y(175.mm, book_size[1], cover_margin_bottom),
  #     font_style: :italic,
  #     font_size: 13,
  #     align: :center, 
  #     line_height: 4.65+1, # +1 too
  #     color: get_prawn_color("151,53,15")

  #   book.sections << inner_cover
  #   book.to_file '/tmp/inner_cover.pdf'
  # end

  # it "should add an introduction" do
  #   book_size = [152.4.mm, 228.6.mm]

  #   page_margin_bottom = 20.mm
  #   book = PDFBook::Document.new(
  #     font: 'Times-Roman',
  #     page_size: book_size,
  #     page_margin_left: 19.05.mm,
  #     page_margin_right: 19.05.mm,
  #     page_margin_top: 15.mm,
  #     page_margin_bottom: 20.mm
  #   )

  #   introduction = PDFBook::Section.new

  #   introduction.add_text "Introduction",
  #     position: get_prawn_y(18.mm+15.mm, book_size[1], page_margin_bottom), # +15.mm: in FPDF, margin only used to set the cursor origin, but coordinate are only relative to the top left corner
  #     font_style: :italic,
  #     font_size: 20,
  #     align: :center, 
  #     color: get_prawn_color("151,53,15")

  #   intro_text = "This is a great intro. " *10
  #   introduction.add_text intro_text,
  #     align: :center,
  #     font_size: 11

  #   book.sections << introduction
  #   book.to_file '/tmp/introduction.pdf'
  # end

  # it "should build a note page" do
  #   book_size = [152.4.mm, 228.6.mm]

  #   margin_bottom = 20.mm
  #   book = PDFBook::Document.new(
  #     font: 'Times-Roman',
  #     page_size: book_size,
  #     page_margin_left: 19.05.mm,
  #     page_margin_right: 19.05.mm,
  #     page_margin_top: 15.mm,
  #     page_margin_bottom: margin_bottom
  #   )

  #   note_page = PDFBook::Section.new

  #   note_page.add_text "Notes",
  #     position: get_prawn_y(25.mm+15.mm, book_size[1], margin_bottom),
  #     font_size: 17,
  #     align: :center,
  #     font_style: :italic,
  #     line_height: 4.65.mm,
  #     gap: 4.65.mm

  #   note_page.add_custom move_down: 2.5.mm

  #   7.times do
  #     note_page.add_custom({
  #       line_width: 0.2.mm,
  #       stroke_horizontal_rule: nil,
  #       move_down: 15.5.mm,
  #     })
  #   end

  #   footer_notes = [
  #     'Printed in Canada',
  #     Time.now.year.to_s
  #   ]
  #   note_page.add_text 'This book was created & published with the help of',
  #     position: get_prawn_y(175.mm, book_size[1], margin_bottom),
  #     font_size: 9,
  #     align: :center,
  #     gap: 4.65.mm
  #   note_page.add_text 'www.HeritageCookbook.com',
  #     font_size: 11,
  #     align: :center, 
  #     gap: 4.65.mm,
  #     font_style: :bold
  #   note_page.add_text footer_notes.join("\n"),
  #     font_size: 9,
  #     align: :center,
  #     line_height: 4.65.mm

  #   book.sections << note_page
  #   book.to_file '/tmp/note_page.pdf'
  # end


  it 'should generate a complex document' do
    book_size = [152.4.mm, 228.6.mm]

    margin_bottom = 20.mm
    book = PDFBook::Document.new(
      font: 'Times',
      page_size: book_size,
      page_margin_left: 19.05.mm,
      page_margin_right: 19.05.mm,
      page_margin_top: 15.mm,
      page_margin_bottom: margin_bottom,
      watermark: "P R E V I E W"
    )

    # Add Arial and Times fonts
    # apt-get install ttf-liberation
    FONT_DIR="/usr/share/fonts/truetype/liberation"
    book.font_families = {
      "Arial" => {  
        bold:        "#{FONT_DIR}/LiberationSans-Bold.ttf",
        italic:      "#{FONT_DIR}/LiberationSans-Italic.ttf",
        bold_italic: "#{FONT_DIR}/LiberationSans-BoldItalic.ttf",
        normal:      "#{FONT_DIR}/LiberationSans-Regular.ttf"
      },
      "Times" => {
        bold:        "#{FONT_DIR}/LiberationSerif-Bold.ttf",
        italic:      "#{FONT_DIR}/LiberationSerif-Italic.ttf",
        bold_italic: "#{FONT_DIR}/LiberationSerif-BoldItalic.ttf",
        normal:      "#{FONT_DIR}/LiberationSerif-Regular.ttf"
      }
    }

    ### Build the cover
    ### ---------------

    cover_margin_bottom = 15.mm+2.mm # should add 2 more mm to be the same as old script 
    cover = PDFBook::Section.new(
      background: @cover_path,
      background_size: :margin,
      page_margin_left: 13.mm,
      page_margin_right: 13.mm,
      page_margin_top: 13.mm,
      page_margin_bottom: cover_margin_bottom
    )

    cover.add_image @large_image_path, 
      position: get_prawn_y(95.mm, book_size[1], cover_margin_bottom),
      max_width: 73.mm,
      max_height: 60.mm,
      mark_image_area: true

    # Draw picture rectangle
    # use user image max height and width
    # x = (page_width - rectangle_width )/ 2-(margin_left + margin_right) /2
    # cover.add_custom(
    #   line_width: 0.6.mm,
    #   rectangle: [ [(book.page_width-73.mm)/2-(13.mm+13.mm)/2, get_prawn_y(95.mm, book_size[1], cover_margin_bottom)], 73.mm, 60.mm ],
    # )
    
    taglines = ["This is the best", "cookbook in the world"]
    cover.add_text taglines.join("\n"),
      position: get_prawn_y(175.mm, book_size[1], cover_margin_bottom),
      font_style: :italic,
      font_size: 13,
      align: :center, 
      line_height: 4.65.mm/2, # /2 is in the old script
      color: get_prawn_color("151,53,15")

    ### Build a blank page
    ### ------------------

    blank_page = PDFBook::Section.new

    ### Build the inner cover
    ### ---------------------

    inner_cover = PDFBook::Section.new(
      background: @inner_cover_path,
      background_size: :margin,
      page_margin_left: 13.mm,
      page_margin_right: 13.mm,
      page_margin_top: 13.mm,
      page_margin_bottom: cover_margin_bottom
    )

    taglines = ["This is the best", "cookbook in the world"]
    inner_cover.add_text taglines.join("\n"),
      position: get_prawn_y(175.mm, book_size[1], cover_margin_bottom),
      font_style: :italic,
      font_size: 13,
      align: :center, 
      line_height: 4.65.mm/2,
      color: get_prawn_color("151,53,15"),
      font: "Helvetica"

    ### Build the introduction
    ### ----------------------

    introduction = PDFBook::Section.new page_number: true

    introduction.add_text "Introduction",
      position: get_prawn_y(18.mm+15.mm, book_size[1], margin_bottom), # +15.mm: in FPDF, margin only used to set the cursor origin, but coordinate are only relative to the top left corner
      font_style: :italic,
      font_size: 20,
      align: :center, 
      gap: 4.65.mm,
      line_height: 4.65.mm,
      color: get_prawn_color("151,53,15")

    intro_text = "This is a great intro.\nThe best cookbook ever made."
    introduction.add_text intro_text,
      align: :center,
      font_size: 11,
      gap: 4.65.mm*2

    introduction.add_image @large_image_path

    ### Build note page
    ### ---------------

    note_page = PDFBook::Section.new(
      page_number: true
    )
    note_page.add_text "Notes",
      position: get_prawn_y(25.mm+15.mm, book_size[1], margin_bottom),
      font_size: 17,
      align: :center,
      font_style: :italic,
      line_height: 4.65.mm,
      gap: 4.65.mm

    note_page.add_custom move_down: 2.5.mm

    7.times do
      note_page.add_custom({
        line_width: 0.2.mm,
        stroke_horizontal_rule: nil,
        move_down: 15.5.mm,
      })
    end

    footer_notes = [
      'Printed in Canada',
      Time.now.year.to_s
    ]
    note_page.add_text 'This book was created & published with the help of',
      position: get_prawn_y(175.mm, book_size[1], margin_bottom),
      font_size: 9,
      align: :center,
      gap: 4.65.mm
    note_page.add_text 'www.HeritageCookbook.com',
      font_size: 11,
      align: :center, 
      gap: 4.65.mm,
      font_style: :bold
    note_page.add_text footer_notes.join("\n"),
      font_size: 9,
      align: :center,
      line_height: 4.65.mm

    ### Create the Table of Content
    ### ---------------------------

    toc_template = PDFBook::Section.new(
      background: @toc_path,
      background_size: :margin,
      page_margin_left: 13.mm,
      page_margin_right: 13.mm,
      page_margin_top: 13.mm,
      page_margin_bottom: cover_margin_bottom
    )

    toc_template.add_text "Table of Contents",
      position: get_prawn_y(50.mm, book_size[1], cover_margin_bottom),
      align: :center, 
      color: get_prawn_color("151,53,15"),
      font_style: :italic,
      font_size: 20

    book.table_of_content(
      template: toc_template,
      width: book_size[0]-(13.mm+28.mm)*2, # width-(margin_left+28+margin_right+28)
      position: get_prawn_y(26+50.mm+4.65.mm, book_size[1], cover_margin_bottom),
      start_at: 3
    )

    ### Build Pasta Section
    ### -------------------

    pasta_section = PDFBook::Section.new(
      background: @divider_path,
      background_size: :margin,
      page_margin_left: 13.mm,
      page_margin_right: 13.mm,
      page_margin_top: 13.mm,
      page_margin_bottom: cover_margin_bottom,
      toc: "Student"
    )

    pasta_section.add_text "Pasta",
      position: get_prawn_y(70.mm, book_size[1], cover_margin_bottom),
      align: :center,
      color: get_prawn_color("151,53,15"),
      font_style: :italic,
      font_size: 20,
      line_height: 4.65.mm,
      gap: 4.65.mm

    # 80 90
    pasta_section.add_image @large_image_path,
      max_width: 80.mm,
      max_height: 90.mm
      
    ### Build Chocolate taste recipe
    ### ----------------------------

    chocolate_taste_recipe_story = PDFBook::Section.new page_number: true

    chocolate_taste_recipe_story.add_image @large_image_path,
      max_width: book.page_width - ( book.margin_options[:left_margin] + book.margin_options[:right_margin] ) + 6.35.mm*2,
      max_height: (book.page_height - ( book.margin_options[:top_margin] + book.margin_options[:bottom_margin] ) - 4.65.mm) / 2 + 10.mm,
      gap: 4.65.mm*2

    chocolate_taste_recipe_story.add_text "This is my favorite !\n I known you will like it !",
      font_size: 11

    chocolate_taste_recipe = PDFBook::Section.new(
      page_number: true,
      index: "Chocolate Taste"
    )

    chocolate_taste_recipe.add_text "Chocolate taste",
      font_size: 17,
      font_style: :bold,
      line_height: 4.65.mm/2

    chocolate_taste_recipe.add_text "Contributed By: kurt!",
      font_size: 11,
      line_height: 4.65.mm

    left_column_ingredients = [
      "Pasta",
      "Chocolate"
    ]

    right_column_ingredients = [
      "Salt",
      "Peeper",
      "Sugar"
    ]

    column_options = {
      font_size: 11,
      line_height: 2,
      gap: 4.65.mm
    }
    chocolate_taste_recipe.add_column_text column_options, 
      left_column_ingredients.join("\n"), 
      right_column_ingredients.join("\n")

    chocolate_taste_recipe.add_text "1/ Put evrything in a cup\n 2/ Burn it!\n 3/ It's ready !",
      font_size: 11

    ### Create the index
    ### ----------------

    index_template = PDFBook::Section.new

    index_template.add_text "Index",
      font_style: :italic,
      font_size: 20,
      line_height: 4.65.mm,
      gap: 4.65.mm


    book.index(
      template: index_template,
      start_at: 3,
      position: get_prawn_y(60+8.mm, book_size[1], margin_bottom)
    )

    ### Create the book
    ### ----------------

    book << cover
    book << blank_page
    book << inner_cover
    book << blank_page
    book << introduction
    book << note_page
    book << :table_of_content
    book << blank_page if book.pages % 2 == 1 # Sections page must always be right
    book << pasta_section
    book << chocolate_taste_recipe_story
    book << chocolate_taste_recipe
    book << :index
    book.to_file '/tmp/book.pdf'

    book.pages.should == 12
  end

  it "should be able to access the last Y position in the last page with content" do
    book_size = [152.4.mm, 228.6.mm]

    margin_bottom = 20.mm
    book = PDFBook::Document.new(
      font: 'Times-Roman',
      page_size: book_size,
      page_margin_left: 19.05.mm,
      page_margin_right: 19.05.mm,
      page_margin_top: 15.mm,
      page_margin_bottom: margin_bottom,
      watermark: "P R E V I E W"
    )

    ### Build Chocolate taste recipe
    ### ----------------------------

    chocolate_taste_recipe_story = PDFBook::Section.new page_number: true

    chocolate_taste_recipe_story.add_image @large_image_path,
      max_width: book.page_width - ( book.margin_options[:left_margin] + book.margin_options[:right_margin] ) + 6.35.mm*2,
      max_height: (book.page_height - ( book.margin_options[:top_margin] + book.margin_options[:bottom_margin] ) - 4.65.mm) / 2 + 10.mm,
      gap: 4.65.mm*2

    chocolate_taste_recipe_story.add_text "This is my favorite !\n I known you will like it !",
      font_size: 11

    chocolate_taste_recipe = PDFBook::Section.new(
      page_number: true,
      index: "Chocolate Taste"
    )

    chocolate_taste_recipe.add_text "Chocolate taste",
      font_size: 17,
      font_style: :bold,
      line_height: 4.65.mm/2

    chocolate_taste_recipe.add_text "Contributed By: kurt!",
      font_size: 11,
      line_height: 4.65.mm

    left_column_ingredients = [
      "Pasta",
      "Chocolate"
    ]

    right_column_ingredients = [
      "Salt",
      "Peeper",
      "Sugar"
    ]

    column_options = {
      font_size: 11,
      line_height: 2,
      gap: 4.65.mm
    }
    chocolate_taste_recipe.add_column_text column_options, 
      left_column_ingredients.join("\n"), 
      right_column_ingredients.join("\n")

    chocolate_taste_recipe.add_text "1/ Put evrything in a cup\n 2/ Burn it!\n 3/ It's ready !",
      font_size: 11

    book << chocolate_taste_recipe_story
    book << chocolate_taste_recipe
    book.to_file '/tmp/recipe.pdf'

    book.pages.should == 2
    book.last_position.to_i.should == 406
  end
end

