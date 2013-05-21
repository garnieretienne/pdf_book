class PDFBook::Part

  attr_accessor :title, :sections

  def initialize(options={})
    @title ||= options[:title]
    @sections = []
  end
end