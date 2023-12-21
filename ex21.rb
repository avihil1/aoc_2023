
require 'set'

DIRECTIONS=[[0, -1], [0, 1], [-1, 0], [1, 0]]
def walk(set_free, current, max_steps=64)
  buffer = [[current]]
  step = 0
  while true
    set_taken = Set.new
    step += 1
    buffer.shift.each {|x,y|
      DIRECTIONS.each {|xx,yy|
        set_taken << [x+xx, y+yy] if set_free.include?([x+xx, y+yy])
      }
    }
    break set_taken.size if step == max_steps
    buffer << set_taken
  end
end

def part1
  set_free = Set.new
  starter = nil
  File.read($file).each_line.with_index {|l, i|
    l.strip.each_char.with_index{|c,j|
      if c == '.'
        set_free << [i,j]
      elsif c == 'S'
        starter = [i,j]
        set_free << [i,j]
      end
    }
  }

  walk(set_free, starter)
end

$file=ARGV[0] || "input21_test"
puts "#{Time.now.to_f}"
puts "Part 1: #{part1}"
puts "#{Time.now.to_f}"
