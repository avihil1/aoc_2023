
def parse(line)
  line.split(',')
end

def ascii(current) = current.ord
def increase_by_ascii(current, other_ascii) = current + other_ascii
def multiple_by(current, num=17) = current * num
def remainder(current, mod=256) = current % mod

def hashing(c, starter)
  remainder(multiple_by(increase_by_ascii(ascii(c), starter)))
end

def part1
  sum = 0
  parsed_all = nil
  File.read($file).each_line {|l|
    parsed_all = parse(l.strip)
  }

  parsed_all.sum {|str|
    starter = 0
    str.chars.each {|c|
      starter = hashing(c, starter)
    }
    starter
  }
end

def type_equal?(s) = s[-1] != '-'

def add_to_box(arr_of_boxes, s, hsh)
  name, val = s.split('=')
  box = hsh[name]

  if box
    # replace value
    arr_of_boxes[box].each.with_index{|(k,v), i|
      if k == name
        arr_of_boxes[box][i][1] = val
        break
      end
    }
  else # add box
    box = 0
    name.chars.each{|c| box = hashing(c, box)}
    hsh[name] = box
    arr_of_boxes[box] << [name, val]
  end
end

def remove_from_box(arr_of_boxes, s, hsh)
  to_remove = s[0..-2]
  box = hsh[to_remove]
  if box
    arr_of_boxes[box].delete_if{|x| x[0] == to_remove }
    hsh.delete(to_remove)
  end
end

def part2
  parsed_all = nil
  File.read($file).each_line {|l|
    parsed_all = parse(l.strip)
  }

  arr_of_boxes = {}
  0.upto(255).each{|i| arr_of_boxes[i] = []}
  h_tracking = {}
  parsed_all.each {|s|
    if type_equal?(s)
      add_to_box(arr_of_boxes, s, h_tracking)
    else # -
      remove_from_box(arr_of_boxes, s, h_tracking)
    end
  }
  calc_sum(arr_of_boxes)
end

def calc_sum(arr_of_boxes)
  arr_of_boxes.sum{|k, arr|
    next 0 if arr.empty?
    box_num = k.to_i + 1
    i = 0
    arr.sum{|_, focal_length|
      i += 1
      box_num.to_i * i * focal_length.to_i
    }
  }
end

$file=ARGV[0] || "input"
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
