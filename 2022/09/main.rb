require './rope_bridge'

lines = []
File.foreach("./moves") { |line| lines.push(line) }

# lines = [
#   'R 2',
#   'D 2',
#   'R 2',
#   'U 1',
#   'R 2',
#   'L 2',
#   'D 1',
#   'L 1',
#   'D 2',
#   'R 2',
#   'U 2',
#   'D 1',
#   'R 2',
#   'D 2',
#   'U 1',
#   'R 1',
#   'D 1',
#   'L 1',
#   'U 1',
#   'R 1',
#   'L 1',
#   'R 2',
#   'U 2',
#   'D 2',
#   'R 2',
#   'L 2',
#   'U 1',
#   'L 2',
#   'U 2',
#   'L 2',
#   'R 2',
#   'U 2',
#   'R 1',
#   'U 2',
#   'L 2',
#   'D 1',
#   'R 1',
#   'U 2',
#   'D 2',
#   'R 2'
# ]

b = RopeBridge.new(500,500, 10)
b.print
lines.each do |d|
  b.move(d)
end
puts b.tail_visited_count
