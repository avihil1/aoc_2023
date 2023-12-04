require 'set'

def key(i,j)
 "#{i},#{j}"
end

def parse(line, line_num, arr, hsh)
  num = ""
  line.chars.each_with_index{|chr, i|
    if chr.ord >= 48 && chr.ord <= 57
      num += chr
      arr << {num: num.to_i, start: i-num.length+1, end: i, line: line_num} if i == line.length-1
    else
      arr << {num: num.to_i, start: i-num.length, end: i - 1, line: line_num} if !num.empty?
      num = ""
      hsh[key(line_num, i)] = chr if chr != '.'
    end
  }
end

def valid_num?(line, start_at, end_at, set)
  ((start_at-1)..(end_at+1)).any?{|col| set.include?(key(line-1, col)) || set.include?(key(line+1, col))} ||
  set.include?(key(line, start_at-1)) ||
  set.include?(key(line, end_at+1))
end

def calc_nums1(arr, set)
  arr.reduce(0) {|sum, dat| 
    valid_num?(dat[:line], dat[:start], dat[:end], set) ? sum + dat[:num] : sum
  }
end

def valid_hsh_star?(hsh, line, col)
  hsh[key(line, col)] == '*'
end

def calc_nums2(arr, hsh)
  h = Hash.new{|h,k| h[k] = []} # prepare 
  arr.each{|dat|
    start_at, end_at, line, num = [dat[:start], dat[:end], dat[:line], dat[:num]]
    ((start_at-1)..(end_at+1)).each {|col| 
      h[key(line-1, col)] << num if valid_hsh_star?(hsh, line-1, col)
      h[key(line+1, col)] << num if valid_hsh_star?(hsh, line+1, col)
    }
    h[key(line, start_at-1)] << num if valid_hsh_star?(hsh, line, start_at-1)
    h[key(line, end_at+1)] << num if valid_hsh_star?(hsh, line, end_at+1)
  }
  
  h.values.map{|x| x[0].to_i * x[1].to_i}.sum
end

def part
  arr = []
  hsh = {}
  File.read($file).each_line.with_index {|l,line_num|
    parse(l.chop, line_num, arr, hsh)
    line_num += 1
  }
  [calc_nums1(arr, hsh), calc_nums2(arr, hsh)]
end


$file=ARGV[0]
part1,part2=part()
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
