require './tree_map'

lines = []
File.foreach("./map") { |line| lines.push(line) }
p = TreeMap.new(lines)
best = p.get_best_scenic_score
puts best[1]
puts best[0]
