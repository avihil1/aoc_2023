
FILE='input1'
def r(s)
  s.gsub('one','1')
   .gsub('two','2')
   .gsub('three', '3')
   .gsub('four', '4')
   .gsub('five', '5')
   .gsub('six', '6')
   .gsub('seven', '7')
   .gsub('eight', '8')
   .gsub('nine', '9')
end

def format_str(s, s2i)
  return s.gsub(/[a-z]/,'') if !s2i

  return r(s.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|1|2|3|4|5|6|7|8|9))/).flatten.join).gsub(/[a-z]/,'')
end

def part(fmt=false)
	sum=0
	File.read(FILE).each_line {|l|
	  arr = []

	  format_str(l.chop, fmt).each_char {|c| arr << c.to_i}

	  sum += arr.last + arr.first*10
	}
	sum
end


puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
