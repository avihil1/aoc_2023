
require 'set'

GALAXY='#'

def add_column(arr, column_num)
  0.upto(arr.length - 1){|i|
    last = arr[i]
    arr[i] = last[..column_num] + '.' + last[column_num+1..]
  }
end

def find_all_galaxies(arr)
  arr.each_with_object([]).with_index{|(row, arr_galaxies), i|
    0.upto(row.size-1){|j|
      arr_galaxies << [i,j] if row[j] == GALAXY
    }
  }
end

def add_empty_column!(arr) = empty_column(arr).reverse.each{|j| add_column(arr, j)}

def empty_column(arr) =
  0.upto(arr[0].length-1).each_with_object([]) {|j, arr_j|
    arr_j << j if 0.upto(arr.size-1).all?{|i| arr[i][j] != GALAXY}
  }

def count_empty(from, to, set)
  from_in = [from, to].min
  to_in   = [from, to].max

  (from_in..to_in).sum{|idx| set.include?(idx) ? 1 : 0}
end

def shortest_paths(arr_pairs, rows_set, column_set, mult)
  len = arr_pairs.size - 1
  0.upto(len).sum {|i|
    (i+1..len).sum {|j|
      x1, y1 = arr_pairs[i]
      x2, y2 = arr_pairs[j]
      (x2-x1).abs + (y2-y1).abs + count_empty(x1, x2, rows_set)*mult + count_empty(y1, y2, column_set)*mult
    }
  }
end

def part
  arr = []
  rows_set = Set.new
  File.read($file).each_line.with_index {|l, i|
    arr << l.strip
    rows_set << i if l.index(GALAXY).nil?
  }
  column_set = Set.new(empty_column(arr))
  arr_galaxies = find_all_galaxies(arr)
  p "[#{Time.now.to_f}] Part1> " + shortest_paths(arr_galaxies, rows_set, column_set, 1).to_s
  p "[#{Time.now.to_f}] Part2> " + shortest_paths(arr_galaxies, rows_set, column_set, 1000000-1).to_s
end

$file=ARGV[0] || "input10"
p "[#{Time.now.to_f}] Start"
part
