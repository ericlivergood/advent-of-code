require './elevation_map'


m = MapBuilder.from_file('./map')
puts 'built'
m.explore
puts 'explored'
puts m.get_shortest_path_length
