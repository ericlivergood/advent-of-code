require './packet_inspector'

lines = []
File.foreach("./input") { |line| lines.push(eval(line)) }

i = PacketInspector.new
#puts i.compute_index_sum(lines)
puts i.get_decoder_key(lines)
