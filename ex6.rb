
def parse(info)
  info.split(':')[1].split.map(&:to_i)
end

def calc_races1(arr)
  mult = 1
  arr[0].each_with_index{|time, idx| 
    mult *= 1.upto(time-1).select{|hold| (time-hold)*hold > arr[1][idx]}.size
  }
  mult
end

def part(part2=false)
  arr = []
  File.read($file).each_line {|l|
    arr << parse(l.chop)
  }
  if part2
    new_arr = [[arr[0].join.to_i], [arr[1].join.to_i]]
    calc_races1(new_arr)  
  else
    calc_races1(arr)  
  end
end

$file=ARGV[0]
puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
