require './underground'


m = MapBuilder.from_file('./scan')
#m.print
puts m.count_til_overflow
#m.print
