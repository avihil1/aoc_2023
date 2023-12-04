
def parse(line)
 card, winning, own = line.split(/[:|]/)
 [card.split[1].to_i, winning.split.map(&:to_i), own.split.map(&:to_i)]
end

def incr(hsh, card, wins, incr_by)
  ((card+1)..(card+wins)).each {|crd| hsh[crd] += incr_by}
end

def part(part2=false)
  sum = 0
  h = Hash.new {|h,k| h[k] = 0}

  File.read($file).each_line {|l|
    card, winning, own = parse(l.chop)
    arr = winning.intersection(own)

    if part2 
      sum += 1 + h[card] # add current card + past refs
      incr(h, card, arr.length, h[card] + 1) unless arr.empty? # mark future
    else
      sum += (2**(arr.length-1)) unless arr.empty?
    end
  }
  sum
end

$file=ARGV[0]
puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
