$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pdf_book'

def get_prawn_y(fpdf_Y)
  720 + 36 - fpdf_Y
end
