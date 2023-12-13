
def add2columns!(columns, parsed)
  if columns.empty?
    parsed.each_char{|c| columns << c}
  else
    parsed.each_char.with_index{|c,i| columns[i] << c}
  end
end

def arr_equal?(arr1, arr2); arr1 == arr2; end

def find_mirror(arr)
  last_place = arr.size - 2
  (0..last_place).each{|i|
    if arr_equal?(arr[i], arr[i+1])
      (1..).each{|idx| # check all mirror
        return (i+1) if i-idx < 0 || i+1+idx > last_place + 1
        break if !arr_equal?(arr[i-idx], arr[i+1+idx])
      }
    end
  }
  0
end

def arr_equal_smudged?(arr1, arr2)
  already_smudged = false
  arr1.each_char.with_index{|c, i|
    if already_smudged
      return [false, false] if c != arr2[i]
    else
      already_smudged = true if c != arr2[i]
    end
  }
  [true, already_smudged]
end

def find_mirror_smudged(arr)
  last_place = arr.size - 2
  (0..last_place).each{|i|
    arrs_equal, smudged = arr_equal_smudged?(arr[i], arr[i+1])
    next if !arrs_equal
    (1..).each{|idx| # check all mirror
      if i-idx < 0 || i+1+idx > last_place + 1
        return (i+1) if smudged
        break
      end
      if !smudged
        equal, smudged = arr_equal_smudged?(arr[i-idx], arr[i+1+idx])
      elsif !arr_equal?(arr[i-idx], arr[i+1+idx])
        break
      end
    }
  }
  0
end

def calc_num(row_num, column_num) = 100*row_num+column_num
def part(part2=false)
  sum = 0
  rows = []
  columns = []
  find_mirror_method = part2 ? :find_mirror_smudged : :find_mirror
  File.read($file).each_line {|l|
    parsed = l.strip
    if parsed.empty?
      row_num    = send(find_mirror_method, rows)
      column_num = send(find_mirror_method, columns)
      sum += calc_num(row_num, column_num)
      rows = []; columns = []
    else
      rows << parsed
      add2columns!(columns, parsed)
    end
  }
  sum
end

$file=ARGV[0] || "input13"
t0 = Time.now.to_f
puts "Part 1 [#{(Time.now.to_f - t0)*1000.0} sec]: #{part}"
t1 = Time.now.to_f
puts "Part 2 [#{(Time.now.to_f - t1)*1000.0} sec]: #{part(true)}"
