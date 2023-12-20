
def parse(line)
  a, b, c = line.split
  [a, b.to_i]#, c.gsub(/[(#)]/,'')]
end


H={"L" =>[0,-1],
   "R" =>[0,1],
   "U" =>[-1,0],
   "D" =>[1,0]}

def walk_thru(arr, commands, ij_start)
  i = ij_start[0]
  j = ij_start[1]
  commands.each{|dir,cnt,_|
    move = H[dir]
    next_i = i + cnt*move[0]
    next_j = j + cnt*move[1]
    if j != next_j
      [j,next_j].min.upto([next_j,j].max){|jj| arr[i][jj] = '#'}
      j = next_j
    else # i diff
      [i,next_i].min.upto([next_i,i].max){|ii|
        arr[ii][j] = '#'
      }
      i = next_i
    end
  }
end


def pt(current, arr)
  i,j = current
  return 0 if i < 0 || j < 0 || i >= arr.length || j >= arr[0].length || arr[i][j] == '#'

  buffer = [] << [i,j]
  cnt = 0
  while !buffer.empty?
    i,j = buffer.pop
    next if i < 0 || j < 0 || i >= arr.length || j >= arr[0].length || arr[i][j] == '#'
    if arr[i][j] = '.'
      arr[i][j] = '#'
      cnt +=1
      buffer << [i-1, j]
      buffer << [i, j+1]
      buffer << [i+1, j]
      buffer << [i, j-1]
    end
  end
  cnt
end

def count_pt(arr)
  ii = arr.length - 1
  jj = arr[0].length - 1
  c1 = 0.upto(ii).sum {|i| pt([i,0], arr)}
  c2 = 0.upto(ii).sum {|i|  pt([i,jj], arr)}
  c3 = 0.upto(jj).sum {|j| pt([0,j], arr)}
  c4 = 0.upto(jj).sum {|j| pt([ii,j], arr)}
  c1+c2+c3+c4
end

def part1
  rows_len = 1
  colums_len = 1
  max_cols = 0
  max_rows = 0
  min_rows = 0
  min_cols = 0
  commands = []
  File.read($file).each_line {|l|
    parsed = parse(l.strip)
    commands << parsed
    case parsed[0]
    when 'D';
      rows_len += parsed[1]
      max_rows = rows_len if rows_len > max_rows
    when 'U';
      rows_len -=parsed[1]
      min_rows = rows_len if rows_len < min_rows
    when 'L';
      colums_len -= parsed[1]
      min_cols = colums_len if colums_len < min_cols
    when 'R';
      colums_len += parsed[1]
      max_cols = colums_len if colums_len > max_cols
    end
  }

  arr = (0..(max_rows-1-min_rows+1)).map{|i| ['.']*(max_cols-min_cols+1)}
  walk_thru(arr, commands, [-min_rows+1, -min_cols+1])
  (max_rows-min_rows+1)*(max_cols-min_cols+1) - count_pt(arr)
end

DIR_TO_ID={"R" => "0", "D" => "1", "L"=>"2", "U" =>"3"}
def parse2(line)
  dir, cnt, _ = line.split
  [cnt.to_i, DIR_TO_ID[dir]]
end

def part1_showlace
  commands = []
  File.read($file).each_line {|l| commands << parse2(l.strip) }
  calc_area(commands)
end

HH={"2" =>[0,-1],  # 2 means L <-
    "0" =>[0,1],   # 0 means R ->
    "3" =>[-1,0],  # 3 means U ^
    "1" =>[1,0]}   # 1 means D v
def calc_area(commands)
  row, col = 0, 0
  sum = 0
  commands.each{|cnt, dir|
    new_row = row + cnt * HH[dir][0]
    new_col = col + cnt * HH[dir][1]
    sum += (col - new_col) * (row + new_row) + cnt
    col, row = new_col, new_row
  }
  sum.abs / 2 + 1
end

def part2
  commands = []
  File.read($file).each_line {|l|
    parsed = l.strip.split.last.gsub(/[(#)]/,'').split(/(\d$)/)
    commands << [parsed[0].hex, parsed[1]]
  }
  calc_area(commands)
end

$file=ARGV[0] || "input"
t0=Time.now
puts "Part 1: #{part1}"
puts "Part 1(shoelace): #{part1_showlace}"
t1=Time.now
puts "#{(t1-t0).to_f}"
puts "Part 2: #{part2}"
puts "#{(Time.now-t1).to_f}"
