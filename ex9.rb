
def parse(info) = info.split.map(&:to_i)

def gaps(arr) = 0.upto(arr.length-2).map{|i| arr[i+1]-arr[i]}

def next_num(arr) = arr.last + (arr.uniq.size == 1 ? 0 : next_num(gaps(arr)))

def part(part1=true)
  sum = 0
  File.read($file).each_line {|l|
    arr = parse(l.chop)
    if part1
      sum += next_num(arr)
    else
      sum += next_num(arr.reverse)
    end
  }
  sum
end

$file=ARGV[0]
puts "Part 1: #{part}"
puts "Part 2: #{part(false)}"
