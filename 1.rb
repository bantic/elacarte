require 'redis'

r = Redis.new
width = 43
lines = 10769
ns = "contest-"

max_rect_area = 0

0.upto(lines) do |line_no|
  0.upto(width) do |pos|
     if rect = find_rect(line_no, pos)
       if rect.area > max_rect_area
         puts "Rect of #{rect.area} found at #{rect.line_no},#{rect.pos}"
         max_rect_area = rect.area
       end
     end
  end
end


def find_rect(line_no, pos)
  if !store?(line_no,pos)
    return nil
  else
    rect = Rect.new(1,1,line_no,pos)
  end     
end

def store?(line_no,pos)
  rkey(line_no,pos) == 'P'
end

def rkey_down(line_no,pos)
  rkey(line_no + 1, pos)
end

def rkey_right(line_no,pos)
  rkey(line_no, pos+1)
end

def rkey(line_no, pos)
  "#{ns}-#{line_no}-#{pos}"
end

class Rect
  attr_accessor :line_no, :pos
  def initialize(width, height, line_no, pos)
    @width = width
    @height = height
    @line_no = line_no
    @pos = pos
  end

  def area
    @width * @height
  end
  
  def expand_right?
    0.upto(@height - 1) do |h|
      return false unless store?( @line_no + h, pos + 1 )
    end
    return true
  end

  def expand_down?
    0.upto(@width - 1) do |w|
      return false unless store?( @line_no + 1, pos + w )
    end
    return true
  end
end

