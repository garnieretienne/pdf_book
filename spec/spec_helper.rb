$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pdf_book'

def get_prawn_y(fpdf_Y, height, margin_bottom)
  height - margin_bottom - fpdf_Y
end
