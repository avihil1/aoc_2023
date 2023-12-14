$rows_map = {}
$metrics_map = {}

TIMES = 1000000000
def add2columns!(columns, parsed)
  if columns.empty?
    parsed.each_char{|c| columns << c}
  else
    parsed.each_char.with_index{|c,i| columns[i] << c}
  end
end

def calc_num(arr, len) =
  arr.map.with_index{|c,i| c == 'O' ? len-i : 0}.sum

def rolling_stones(row)
  $rows_map[row] ||= begin # memoize
    head_free = nil
    row_new = []
    0.upto(row.length-1){|i|
      c = row[i]
      if c == '#'
        row_new << c
        head_free = nil
      elsif c == 'O'
        if head_free
          row_new[head_free] = c
          row_new << '.'
          head_free += 1
        else
          row_new << c
        end
      else # c == '.'
        head_free = i if head_free == nil
        row_new << c
      end
    }
    row_new.join
  end
end

def part1
  columns = []
  sum = 0
  File.read($file).each_line {|l|
    parsed = l.strip
    add2columns!(columns, parsed)
  }

  columns.sum{|column|
    column_rolled = rolling_stones(column)
    calc_num(column_rolled.chars, column_rolled.size)
  }
end

def transpose(rows)
  column_new = []
  rows.each {|row| add2columns!(column_new, row) }
  column_new
end

def cyclic?(arr)
  (0..arr.length-3).all?{|i| arr[i] - arr[i+1] == arr[i+1] - arr[i+2]}
end

def calc_last_time_before_1b(last_idx, arr)
  gap_rule = arr[1] - arr[0]
  last_idx = TIMES - last_idx - gap_rule # helping the counter
  while last_idx + gap_rule < TIMES
    last_idx += gap_rule
  end
  last_idx
end

def rolling_h(data, direction)
  data.map {|row|
    if direction == 'west' || direction == 'north'
      rolling_stones(row)
    else # west, east
      rolling_stones(row.reverse).reverse
    end
  }
end

def rolling_v(data, direction)
  transpose( rolling_h(transpose(data), direction) )
end

$metrics_counter ||= Hash.new{|h,k| h[k] = []}
def cycle(columns, i, jumped)
  if $metrics_map[columns]
    if !jumped
      $metrics_counter[columns] << i
      if $metrics_counter[columns].size > 3 && cyclic?($metrics_counter[columns])
        jump_to = calc_last_time_before_1b(i, $metrics_counter[columns])
        return [jump_to, columns]
      end
    end

    return [-1, columns = $metrics_map[columns]]
  end

  cloned_cols = columns.clone
  columns = rolling_v(columns, 'north') # ^north
  columns = rolling_h(columns, 'west') # <  west
  columns = rolling_v(columns, 'south') # \/ south
  columns = rolling_h(columns, 'east') # >  east
  [-1, $metrics_map[cloned_cols] = columns]
end

def part2
  rows = []
  File.read($file).each_line {|l| rows << l.strip}

  idx = 0
  jumped = false
  while true
    jump_to, rows = cycle(rows, idx, jumped)
    if jump_to > 0 && !jumped
      jumped = true
      idx = jump_to - 1 # -1, because we increment the idx after
    end
    idx += 1
    break if idx == TIMES
  end

  transpose(rows).sum{|row| calc_num(row.chars, row.length)}
end

$file=ARGV[0] || "input14"
puts "Part 1: #{part1}"
t= Time.now.to_f
puts "Part 2: #{part2}"
puts "#{(Time.now-t).to_f.round(2)} sec"
