require 'spec_helper'

describe PDFBook do
  before do
    @slim_image_path = "#{File.dirname(__FILE__)}/fixtures/files/slim.jpg"
    @large_image_path = "#{File.dirname(__FILE__)}/fixtures/files/large.jpg"
    @highter_image_path = "#{File.dirname(__FILE__)}/fixtures/files/highter.jpg"
    @gray_divider_path = "#{File.dirname(__FILE__)}/fixtures/files/gray_divider.jpg"
  end

  it 'should have a version number' do
    PDFBook::VERSION.should_not be_nil
  end

  it 'should create a new document' do
    PDFBook::Document.new
  end

  it 'should export a pdf' do
    book = PDFBook::Document.new
    book.to_pdf
  end

  it 'should create a new section' do
    section = PDFBook::Section.new(title: 'My Story')
  end

  it 'should create a new text content' do
    content = PDFBook::Content::Text.new "Hello World"
    content.data.should == "Hello World"
  end

  it 'should create a new column text content' do
    content = PDFBook::Content::ColumnText.new "Hello World", "Foo Bar"
    content.data.count.should == 2
    content.data.first.should == "Hello World"
  end

  it 'should create a new image content' do
    content = PDFBook::Content::Image.new @large_image_path
    content.data.should == @large_image_path
    content.width.should == 1035
    content.height.should == 1020
  end

  it 'should create a new chapter' do
    chapter = PDFBook::Content::Chapter.new 'Chapter 1'
    chapter.data.should == 'Chapter 1'
  end

  it 'should add text content to a section' do
    section = PDFBook::Section.new(title: 'Introduction')
    section.add_text "Hello World"
    section.contents.count.should == 1
    section.contents.first.class.should be PDFBook::Content::Text
    section.contents.first.data.should == "Hello World"
  end

  it 'should add a column text content to a section' do
    section = PDFBook::Section.new(title: 'List')
    section.add_column_text "Left side", "Right side"
    section.contents.count.should == 1
    section.contents.first.class.should be PDFBook::Content::ColumnText
    section.contents.first.data.last.should == "Right side"
  end

  it 'should add an image content to a section' do
    section = PDFBook::Section.new(title: 'Logo')
    section.add_image @slim_image_path
    section.contents.count.should == 1
    section.contents.first.class.should be PDFBook::Content::Image
  end

  it 'should add a section to a document' do
    doc = PDFBook::Document.new
    doc.sections << PDFBook::Section.new(title: 'Introduction')
    doc.sections.count.should == 1
    doc.sections.first.class.should be PDFBook::Section
    doc.sections.first.title.should == 'Introduction'
  end

  it 'should set a background image on every pages of the section' do
    doc = PDFBook::Document.new
    doc.sections << PDFBook::Section.new(background: @large_image_path)
    doc.sections.first.background.should == @large_image_path
  end




  it 'should generate a complex document' do
    book = PDFBook::Document.new note_page: true

    introduction = PDFBook::Section.new(title: 'Introduction')
    introduction.add_text("This is the first paragraph")
    introduction.add_text("This is the second paragraph")

    introduction.add_column_text("Left column\nIs important", "Right column")

    gallery = PDFBook::Section.new(title: 'Gallery')
    gallery.add_image(@slim_image_path)
    gallery.add_text("A little bigger ...")
    gallery.add_image(@large_image_path)
    gallery.add_text("Portrait mode:")
    gallery.add_image(@highter_image_path)

    blank_page = PDFBook::Section.new
    full_page_image = PDFBook::Section.new(title: "Awesome", background: @gray_divider_path)

    book.sections << introduction
    book.sections << blank_page
    book.sections << blank_page
    book.sections << full_page_image
    book.sections << gallery
    book.to_file '/tmp/book.pdf'
  end

end
