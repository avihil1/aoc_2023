
def parse(info,h)
  pattern, rank = info.split
  h[pattern] = rank.to_i
  pattern
end

class Ordering
  @@hash_order = {}
  @@order = 'AKQT98765432J'.freeze
  def self.init_order_hash
    if @@hash_order.empty?
      @@order.chars.each_with_index { |chr, idx| @@hash_order[chr] = -idx }
    end
  end

  # Return the order from the hash, or return to_i
  # to_i will return the int presentation if exists or 0
  def self.order(str)
    init_order_hash if @@hash_order.empty?
    str.chars.map { |c| @@hash_order[c] || c.to_i }
  end
end

def calc_rank(h_ranks)
  h = Hash.new {|h,k| h[k] = 0}
  h_ranks.values.each{|rank| h[rank] += 1}
  j_times = h_ranks['J'].to_i

  if h.include?(5)
    5
  elsif h.include?(4)
    j_times > 0 ? 5 : 4
  elsif h.include?(3)
    if h.include?(2)
      j_times > 0 ? 5 : 3.5
    else
      j_times > 0 ? 4 : 3
    end
  elsif h.include?(2) # and not 3!
    if h[2] == 2 # 2 * 2
      if j_times == 0 # 2+2
        2.5
      elsif j_times == 1 # 2 + 2 + J => 3+2
        3.5
      else # J = 2
        4
      end
    else # one pair of 2
      j_times > 0 ? 3 : 2
    end
  else
    1 + j_times
  end
end

def rank(s)
  h = Hash.new {|h,k| h[k] = 0}
  s.chars.each{|c| h[c] += 1}
  calc_rank(h)
end

def part2
  sum = 0
  h_rank = {}
  arr_of_camels = []
  File.read($file).each_line {|l|
    pattern = parse(l.strip, h_rank)
    arr_of_camels << [pattern, rank(pattern)]
  }

  arr_of_camels.sort_by{|key, internal_rank|
    [internal_rank, Ordering.order(key)]
  }.each_with_index {|(key,rank), i|
    sum += ((i+1) * h_rank[key])
  }

  sum
end

$file=ARGV[0]
puts "Part 2: #{part2}"
