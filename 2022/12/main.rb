require './elevation_map'


m = MapBuilder.from_file('./map')
m.compute_path
#m.print
puts "#{m.end}"

# maps = TrailBuilder.from_file('./map')
# min = 100000
# n = 1
# maps.each do |m|
#   puts "Computing #{n}"
#   m.compute_path
#   min = m.end.distance if(m.end.distance < min)
#   n += 1
# end
# puts min
