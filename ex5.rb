
def parse(info, header=false)
  if header
    info.split[0].split('-') # seed-to-soil map: => [seed, to, soil]
  else
    info.split.map(&:to_i)
  end
end

def parse_seeds(info)
  info.split(':')[1].split.map(&:to_i)
end

def next_val(h, hsh_name, val)
  h[hsh_name][:ranges].each{|_s, _e, _replace|
    if _s <= val && val <= _e
      val = _replace + (val - _s)
      break
    end
  } 

  [h[hsh_name][:next], val]
end

def next_val_bsearch(h, hsh_name, val)
  arr = h[hsh_name][:ranges].bsearch{|_s, _e, _r| val < _s ? -1 : val > _e ? 1 : 0 }
  val = arr[2] + (val - arr[0]) unless arr.nil?
  [h[hsh_name][:next], val]
end

def location(seed, hsh)
  loc = seed
  hsh_name = "seed"
  while hsh_name != "location"
    hsh_name, loc = next_val_bsearch(hsh, hsh_name, loc) # [next_hsh_name, loc]
  end
  loc  
end

def find_locations(seeds, h)
  seeds.map{|seed| location(seed, h)}
end

def find_locations2(seeds, h)
  min = 9999999999999 
  seeds.each_slice(2){|_start, _len|
     p "[#{Time.now}] slice #{_start} => #{_len}"
    _start.upto(_start+_len-1).each {|seed| 
      loc = location(seed, h)
      min = loc if loc < min
    }
  }
  min
end

def part(part2=false)
  first=false
  header = false
  seeds = []
  h = {}
  last = nil
  File.read($file).each_line {|l|
    l.chop!

    if l.empty?
      header = true
      next
    end

    if !first
      seeds = parse_seeds(l)
      first = true
    else
      dat = parse(l, header)
      if header
        h[dat[0]] = {next: dat[2], ranges: []}
        last = h[dat[0]]
      else
        last[:ranges] << [dat[1], dat[1]+dat[2]-1, dat[0]] # start, end, map2first
        last[:ranges].sort!
      end
      header=false
    end
  }

  if part2
    find_locations2(seeds, h)
  else
    find_locations(seeds, h).min
  end
end

$file=ARGV[0]
puts "Part 1: #{part}"
puts "Part 2: #{part(true)}"
