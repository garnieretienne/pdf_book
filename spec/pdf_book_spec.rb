require 'spec_helper'

describe PdfBook do
  it 'should have a version number' do
    PdfBook::VERSION.should_not be_nil
  end

  it 'should do something useful' do
    false.should be_true
  end
end
