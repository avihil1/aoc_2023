
FILE='input2'
RULES={"red"=>12, "green" => 13, "blue"=>14}

def parse(info)
  game, cubes = info.split(':') 
  [
   game.split.last.to_i,
   cubes.split(';').map{|set| set.split(',').map(&:split).map{|v,k| {k => v.to_i}}.reduce({}, :merge)}
  ]
end

def possible?(cubes)
  cubes.all? {|h| 
    h.all? {|k,v| v <= RULES[k]} 
  }
end

def multi_max(cubes)
  cubes.reduce({}) {|h, item| 
    item.each{|k,v| h[k] = v if h[k].to_i < v}
    h
  }
  .values
  .reduce(&:*)
end

def part(part2=false)
  sum = 0
  File.read(FILE).each_line {|l|
    game_num, cubes = parse(l.chop)

    if !part2
      sum += game_num if possible?(cubes)
    else
      sum += multi_max(cubes)
    end
  }
  sum
end


puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
