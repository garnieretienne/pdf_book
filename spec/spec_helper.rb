$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pdf_book'

def get_prawn_y(fpdf_Y, height, margin_bottom)
  height - margin_bottom - fpdf_Y
end

def get_prawn_color(fpdf_color_string)
  rgb = fpdf_color_string.split(',')
  return "#{int2hex(rgb[0].to_i)}#{int2hex(rgb[1].to_i)}#{int2hex(rgb[2].to_i)}"
end

private

def int2hex(int)
  if int < 16
    return "0#{int.to_s(16)}"
  else
    return int.to_s(16)
  end
end
