
FILE='input1'

NUMS=['','one','two','three','four','five','six','seven', 'eight', 'nine']
def replace(s); NUMS.index(s) || s; end

def format_str(s, s2i)
  return s.gsub(/[a-z]/,'').chars if !s2i

  s.scan(/(?=(#{NUMS[1..-1].join("|")}|1|2|3|4|5|6|7|8|9))/).flatten.map(&method(:replace))
end

def part(fmt=false)
  sum=0
  File.read(FILE).each_line {|l|
    arr = format_str(l.chop, fmt)
    sum += arr.last.to_i + arr.first.to_i*10
  }
  sum
end


puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
