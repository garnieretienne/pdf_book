require 'spec_helper'

describe PDFBook do
  it 'should have a version number' do
    PDFBook::VERSION.should_not be_nil
  end

  it 'should create a new book' do
    book = PDFBook::Document.new
  end

  it 'should export a pdf' do
    book = PDFBook::Document.new
    book.to_pdf '/tmp/test.pdf'
  end

  it 'should create a new part' do
    book_part = PDFBook::Part.new(title: 'My Story')
    book_part.title.should == 'My Story'
  end

  it 'should create a new section' do
    section = PDFBook::Section.new
    section.layout.should be :plain
  end

  it 'should create a new text content' do
    content = PDFBook::Content::Text.new "Hello World"
    content.text.should == "Hello World"
  end

  it 'should add text content to a section' do
    section = PDFBook::Section.new
    section.add_text "Hello World"
    section.contents.count.should == 1
    section.contents.first.class.should be PDFBook::Content::Text
    section.contents.first.text.should == "Hello World"
  end

  it 'should return the max row number occuped by a section contents' do
    multiline_text = " Hello I'm a multiline String,
                       And I like it."
    section = PDFBook::Section.new
    section.add_text "I'm a String !"
    section.add_text multiline_text
    section.max_lines.should  == 2
  end

  it 'should add a section to a document part' do
    book_part = PDFBook::Part.new(title: 'My Story')
    book_part.sections << PDFBook::Section.new
    book_part.sections.count.should == 1
    book_part.sections.first.class.should be PDFBook::Section
  end

  it 'should add a book part to a document' do
    doc = PDFBook::Document.new
    doc.parts << PDFBook::Part.new(title: 'Introduction')
    doc.parts.count.should == 1
    doc.parts.first.class.should be PDFBook::Part
    doc.parts.first.title.should == 'Introduction'
  end

  it 'should generate a complex document' do
    book = PDFBook::Document.new

    introduction = PDFBook::Part.new(title: 'Introduction')
    introduction.sections << PDFBook::Section.new.add_text("This is the first paragraph")
    introduction.sections << PDFBook::Section.new.add_text("This is the second paragraph")

    table = PDFBook::Section.new(layout: :column)
    table.add_text("Left column\nIs important")
    table.add_text("Right column")
    introduction.sections << table

    book.parts << introduction
    book.to_pdf '/tmp/book.pdf'
  end

end
