def parse(info) = info.split(/[=(), ]/).select{|a| !a.empty?}

def next_action(actions, i) = actions[i % actions.size]

def steps(node, h, actions, &block) =
  (0...).each {|step|
    break step if block.call(node)
    node = h[node][ next_action(actions, step) ]
  }

def steps_to_zz_tripo2(h, actions) =
  h.select{|node| node['A']}.keys.map{|node|
    steps(node, h, actions) { h[_1]['Z'] }
  }.reduce(&:lcm)

def part
  actions = nil
  h = {}
  File.read($file).each_line {|l|
    l.strip!

    if !actions
      actions = l.chars
      next
    end
    next if l.empty?

    node, left, right = parse(l)
    h[node] = {'L' => left, 'R' => right, 'Z' => node.end_with?('Z')}
  }
  puts "Part1", steps('AAA', h, actions) { _1 == 'ZZZ' }
  puts "Part2", steps_to_zz_tripo2(h, actions)
end

$file=ARGV[0]
part()
