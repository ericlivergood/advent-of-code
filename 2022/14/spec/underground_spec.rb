require './underground'

describe Underground do
#   0 1 2 E 4
# 0 . . . . .
# 1 . . . . .
# 2 . . . . .
# 3 . . . . .
# 4 . . . . .
# 5 . # # # #
# 6 a a a a a

#   0 1 2 E 4
# 0 . . . . .
# 1 . . . . .
# 2 . . . . .
# 3 . . . 4 .
# 4 .  2 1 3
# 5 . # # # #
# 6 5 a a a a

test_map = [
  Point.new(1,5),
  Point.new(2,5),
  Point.new(3,5),
  Point.new(4,5)
]

  it 'gets next sand location' do
    u = Underground.new(test_map, 3)

    loc = u.next_sand_location(3, 0)
    expect(loc.x).to eql(3)
    expect(loc.y).to eql(1)

    loc = u.next_sand_location(3, 1)
    expect(loc.x).to eql(3)
    expect(loc.y).to eql(2)

    loc = u.next_sand_location(3, 4)
    expect(loc).to eql(nil)

    loc = u.next_sand_location(3, 4)
    expect(loc).to eql(nil)

    loc = u.next_sand_location(0, 5)
    expect(loc).to eql(:abyss)

    loc = u.next_sand_location(1, 6)
    expect(loc).to eql(:abyss)
  end

  it 'adds sand' do
    u = Underground.new(test_map, 3)
    u.add_sand
    expect(u.map[3][4]).to eql(:sand)

    u.add_sand
    expect(u.map[2][4]).to eql(:sand)

    u.add_sand
    expect(u.map[4][4]).to eql(:sand)

    u.add_sand
    expect(u.map[3][3]).to eql(:sand)
  end

  it 'runs test' do

  end

  it 'counts sand' do
    u = Underground.new(test_map, 3)
    expect(u.count_sand).to eql(4)
  end

  it 'counts from test input' do
    inputs = [
      '498,4 -> 498,6 -> 496,6',
      '503,4 -> 502,4 -> 502,9 -> 494,9'
    ]
    puts ''
    m = MapBuilder.build(inputs)
    #(0..92).each {|i| m.add_sand}
    #expect(m.count_sand).to eql(24)
    expect(m.count_til_overflow).to eql(93)
    m.print(490)
  end
end
