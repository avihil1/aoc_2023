

def valid?(len_rows, len_cols, i, j)
  i >= 0 && i < len_rows && j >= 0 && j < len_cols
end

LEFT=[0,-1]
RIGHT=[0,1]
UP=[-1,0]
DOWN=[1,0]

def degrees_90_direction(i_diff, j_diff, chr)
  # if chr == '\'
  dir = if j_diff < 0
    UP
  elsif j_diff > 0
    DOWN
  elsif i_diff < 0
    LEFT
  else # i_diff > 0
    RIGHT
  end

  chr == '/' ? dir.map{|x| -x} : dir
end

def move(i, j, direction, arr, h)
  next_i = i + direction[0]
  next_j = j + direction[1]

  case arr[i][j]
  when '|'
    if direction[0] != 0 # vertical move
      [[next_i, next_j, direction]]
    else
      [[i-1, j, UP],[i+1, j, DOWN]]
    end
  when '-'
    if direction[0] != 0 # vertical move
      [[i, j-1, LEFT],[i, j+1, RIGHT]]
    else
      [[next_i, next_j, direction]]
    end
  when '\\'
    dir = degrees_90_direction(direction[0], direction[1], arr[i][j])
    [[i + dir[0], j + dir[1], dir]]
  when '/'
    dir = degrees_90_direction(direction[0], direction[1], arr[i][j])
    [[i + dir[0], j + dir[1], dir]]
  else # '.'
    [[next_i, next_j, direction]]
  end
end

def key(i,j) = "#{i},#{j}"
def energizing(h, i, j, dir)
  if h[key(i,j)]
    h[key(i,j)][dir] = true
  else
    h[key(i,j)] = {dir => true}
  end
end

def already_energized?(h, i, j, direction)
  ener = h[key(i,j)]
  !ener.nil? && ener[direction]
end

DIR = {UP => "UP", DOWN => "DOWN", RIGHT => "RIGHT", LEFT => "LEFT"}

def walk_thru(arr, h, buffer)
  i,j,dir = buffer[0]
  energizing(h,i,j,dir)
  cnt = 0
  rows_len = arr.size
  colums_len = arr[0].size
  while true
    break if buffer.empty?
    i, j, direction = buffer.shift
    next_move = move(i, j, direction, arr, h)
    next_move.each{|place|
      if !place.nil? && !place.empty? && valid?(rows_len, colums_len, place[0], place[1]) && !already_energized?(h, place[0], place[1], place[2])
        buffer << place
        energizing(h, place[0], place[1], place[2])
      end
    }
  end
end

def part(part2=false)
  arr = []
  File.read($file).each_line {|l|
    arr << l.strip.chars
  }

  if !part2
    h_energized = {}
    walk_thru(arr, h_energized, buffer = [ [0, 0, RIGHT] ])
    h_energized.keys.size
  else
    max_tiles = 0
    [UP, DOWN, LEFT, RIGHT].each{|dir|
      0.upto(arr.size-1) {|i|
        0.upto(arr[0].size-1) {|j|
          next if i != 0 && i !=(arr.size-1) && j !=0 && j != (arr[0].size-1)
          h_energized = {}
          walk_thru(arr, h_energized, buffer = [ [i, j, dir] ])
          max_tiles = h_energized.keys.size if h_energized.keys.size > max_tiles
        }
      }
    }
    max_tiles
  end
end

$file=ARGV[0] || "input"
t0 = Time.now
puts "Part 1: #{part}"
t1 = Time.now
puts "#{(t1-t0).to_f}"
puts "Part 2: #{part(true)}"
puts "#{(Time.now-t1).to_f}"
