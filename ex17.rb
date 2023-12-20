require 'set'

class PQueue

  def initialize(elements=nil, &block) # :yields: a, b
    @que = []
    @cmp = block || lambda{ |a,b| b <=> a }
    replace(elements) if elements
  end

 protected


  attr_reader :que #:nodoc:

 public


  attr_reader :cmp


  def size = @que.size

  alias length size

  def push(v)
    @que << v
    reheap(@que.size-1)
    self
  end

  alias enq push
  alias :<< :push


  def pop
    return nil if empty?
    @que.pop
  end

  alias deq pop


  def shift
    return nil if empty?
    @que.shift
  end

  def top
    return nil if empty?
    return @que.last
  end


  alias peek top

  def replace(elements)
    if elements.kind_of?(PQueue)
      initialize_copy(elements)
    else
      @que.replace(elements.to_a)
      sort!
    end
    self
  end

  def empty? = @que.empty?
  def to_a = @que.dup
  def inspect = "<#{self.class}: size=#{size}, top=#{top || "nil"}>"
  def ==(other) = size == other.size && to_a == other.to_a

 private

  def initialize_copy(other)
    @cmp  = other.cmp
    @que  = other.que.dup
    sort!
  end

  def reheap(k)
    return self if size <= 1

    que = @que.dup

    v = que.delete_at(k)
    i = binary_index(que, v)

    que.insert(i, v)

    @que = que

    return self
  end

  #
  # Sort the queue in accorance to the given comparison procedure.
  #
  def sort!
    @que.sort! do |a,b|
      case @cmp.call(a,b)
      when  0, nil   then  0
      when  1, true  then  1
      when -1, false then -1
      else
        warn "bad comparison procedure in #{self.inspect}"
        0
      end
    end
    self
  end


  alias heapify sort!

  def binary_index(que, target)
    upper = que.size - 1
    lower = 0

    while(upper >= lower) do
      idx  = lower + (upper - lower) / 2
      comp = @cmp.call(target, que[idx])

      case comp
      when 0, nil
        return idx
      when 1, true
        lower = idx + 1
      when -1, false
        upper = idx - 1
      else
      end
    end
    lower
  end

end # class PQueue

# [cur+i, cur+j, nogo]
H_DIR={up: [-1,0, :down], down: [1,0, :up], right: [0,1, :left], left: [0,-1, :right]}

def out_of_borders?(i, j, arr)
  i < 0 || i > (arr.size - 1) || j < 0 || j > (arr[0].size - 1)
end

def move(elem, arr, set, min=1, max=3)
  orig_sum, x, y, dir  = elem
  ret = []
  [:up, :down, :right, :left].each{|next_dir|
    next if H_DIR[dir][2] == next_dir # counter direction
    next if dir == next_dir

    sum = orig_sum
    (1..max).each{|i|
      next_i = x+i*H_DIR[next_dir][0]
      next_j = y+i*H_DIR[next_dir][1]
      break if out_of_borders?(next_i, next_j, arr)

      sum += arr[next_i][next_j]

      next if set.include?(key(next_i, next_j, next_dir))

      ret << [sum, next_i, next_j, next_dir] if i >= min
    }
  }
  ret
end


def key(*keys) = :"#{keys.join('.')}"

def walk_thru(arr, min, max)
  rows_len = arr.size
  colums_len = arr[0].size
  buffer = PQueue.new
  buffer << [0, 0, 0, :right]
  buffer << [0, 0, 0, :down]

  min_global = 99999
  set = Set.new

  while true
    break if buffer.empty?
    e = buffer.pop
    if e[1] == rows_len - 1 && e[2] == colums_len - 1
      min_global = e[0] if min_global > e[0]
    else
      next if e[0] >= min_global
    end

    k = key(e[1],e[2],e[3])
    next if set.include?(k)
    set << k

    move(e, arr, set, min, max).each{|e| buffer << e}
  end
  min_global
end

def part(min, max)
  arr = []
  File.read($file).each_line {|l|
    arr << l.strip.chars.map(&:to_i)
  }
  walk_thru(arr, min, max)
end

$file=ARGV[0] || "input"
t0 = Time.now
puts "Part 1: #{part(1,3)}"
t1= Time.now
puts "#{(t1-t0).to_f}"
puts "Part 2: #{part(4,10)}"
puts (Time.now-t1).to_f
