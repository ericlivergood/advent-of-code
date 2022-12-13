require './elevation_map'

describe ElevationMap do
  it 'detects ability to move' do
    map_array = [
      [0, 0, 0],
      [0, 1, 0],
      [0, 3, 0],
    ]
    # ^ flips x & y visually
    # 0 0 0
    # 0 1 3
    # 0 0 0

    m = ElevationMap.new(MapPoint.new(0,0), nil, map_array)

    expect(m.can_move_up?).to eql(false)
    expect(m.can_move_down?).to eql(true)
    expect(m.can_move_left?).to eql(false)
    expect(m.can_move_right?).to eql(true)

    m = ElevationMap.new(MapPoint.new(1,1), nil, map_array)

    expect(m.can_move_up?).to eql(true)
    expect(m.can_move_down?).to eql(true)
    expect(m.can_move_left?).to eql(true)
    expect(m.can_move_right?).to eql(false)

    m = ElevationMap.new(MapPoint.new(2,0), nil, map_array)

    expect(m.can_move_up?).to eql(false)
    expect(m.can_move_down?).to eql(false)
    expect(m.can_move_left?).to eql(true)
    expect(m.can_move_right?).to eql(false)

    m = ElevationMap.new(MapPoint.new(0,2), nil, map_array)

    expect(m.can_move_up?).to eql(true)
    expect(m.can_move_down?).to eql(false)
    expect(m.can_move_left?).to eql(false)
    expect(m.can_move_right?).to eql(true)

    m = ElevationMap.new(MapPoint.new(2,2), nil, map_array)

    expect(m.can_move_up?).to eql(false)
    expect(m.can_move_down?).to eql(false)
    expect(m.can_move_left?).to eql(true)
    expect(m.can_move_right?).to eql(false)

  end

  it 'generates movement options' do
    map_array = [
      [0, 0, 0],
      [0, 1, 0],
      [0, 3, 0],
    ]
    # ^ flips x & y visually
    # 0 0 0
    # 0 1 3
    # 0 0 0

    m = ElevationMap.new(MapPoint.new(0,0), nil, map_array)

    options = m.movement_options
    expect(options.length).to eql(2)
    expect(options[0]).to eql(:down)
    expect(options[1]).to eql(:right)

    m = ElevationMap.new(MapPoint.new(1,1), nil, map_array)
    options = m.movement_options
    expect(options.length).to eql(3)
    expect(options[0]).to eql(:up)
    expect(options[1]).to eql(:down)
    expect(options[2]).to eql(:left)


    m = ElevationMap.new(MapPoint.new(2,2), nil, map_array)
    options = m.movement_options
    expect(options.length).to eql(1)
    expect(options[0]).to eql(:left)
    expect(m.can_move_up?).to eql(false)
    expect(m.can_move_down?).to eql(false)
    expect(m.can_move_left?).to eql(true)
    expect(m.can_move_right?).to eql(false)
  end

  it 'detects finding end' do
    point1 = MapPoint.new(0,0)
    point2 = MapPoint.new(0,0)
    point3 = MapPoint.new(0,1)
    point4 = MapPoint.new(1,1)

    expect(ElevationMap.new(point1, point1, [[]]).is_at_end?).to eql(true)
    expect(ElevationMap.new(point1, point2, [[]]).is_at_end?).to eql(true)
    expect(ElevationMap.new(point1, point3, [[]]).is_at_end?).to eql(false)
    expect(ElevationMap.new(point1, point4, [[]]).is_at_end?).to eql(false)

  end

  it 'computes equality' do
    x = PersonLocation.new(1,1)
    y = MapPoint.new(1,1)
    z = MapPoint.new(2,2)

    expect(x == y).to eql(true)
    expect(y == x).to eql(true)

    expect(x == z).to eql(false)
    expect(z == x).to eql(false)

    expect(y == z).to eql(false)
    expect(z == y).to eql(false)
  end

  it 'moves person' do
    x = PersonLocation.new(1,1)
    x = x.move(:down)
    expect(x.x).to eql(1)
    expect(x.y).to eql(2)

    x = x.move(:right)
    expect(x.x).to eql(2)
    expect(x.y).to eql(2)

    x = x.move(:up)
    expect(x.x).to eql(2)
    expect(x.y).to eql(1)

    x = x.move(:left)
    expect(x).to eql(nil)

    x = PersonLocation.new(1,1)
    x = x.move(:down)
    x = x.move(:down)
    x = x.move(:down)
    expect(x.move(:up)).to eql(nil)
    x = x.move(:down)
    expect(x.x).to eql(1)
    expect(x.y).to eql(5)
  end

  it 'navigates to end' do
    map_array = [
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]

    s = MapPoint.new(0,0)
    e = MapPoint.new(0,7)

    m = ElevationMap.new(s, e, map_array)
    m.explore
    expect(m.viable_paths.length).to eql(1)
    expect(m.viable_paths[0].path.length).to eql(7)
  end


  it 'navigates to end' do
    map_array = [
      [0, 2, 2, 0, 2, 2, 2, 2],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [2, 0, 2, 2, 2, 2, 0, 0]
    ]

    # 0 0 2  #0
    # 2 0 0  #1
    # 2 0 2  #2
    # 0 0 2  #3
    # 2 0 0  #4
    # 2 2 0  #5
    # 2 0 0  #6
    # 2 0 0  #7
    ##########
    # 0 1 2

    s = MapPoint.new(0,0)
    e = MapPoint.new(2,7)

    m = ElevationMap.new(s, e, map_array)
    m.explore

    expect(m.viable_paths.length).to eql(2)
    expect(m.viable_paths[0].path.length).to eql(9)
    expect(m.viable_paths[1].path.length).to eql(9)
  end

  it 'builds a map' do
    s ='
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    '


    #Path
    # v..v<<<<
    # >v.vv<<^
    # .>vv>E^^
    # ..v>>>^^
    # ..>>>>>^

    m = MapBuilder.from_strings(s)

    expect(m.current.x).to eql(0)
    expect(m.current.y).to eql(0)
    expect(m.end.x).to eql(5)
    expect(m.end.y).to eql(2)
    m.explore

    # m.viable_paths.each do |p|
    #   puts p.path.length
    # end
    expect(m.get_shortest_path_length).to eql(31)
  end

end
