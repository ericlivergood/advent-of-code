require './elevation_map'

describe MapPoint do
  it 'adds neighbors' do
    m = MapPoint.new(0, 0, 5)
    m.add_neighbor(MapPoint.new(1, 1, 5))
    expect(m.neighbors.length).to eql(1)

    m.add_neighbor(MapPoint.new(1, 1, 6))
    expect(m.neighbors.length).to eql(2)

    m.add_neighbor(MapPoint.new(1, 1, 7))
    expect(m.neighbors.length).to eql(2)

    m.add_neighbor(MapPoint.new(1, 1, 4))
    expect(m.neighbors.length).to eql(3)
  end

  it 'sets distance' do
    m = MapPoint.new(0, 0, 5)
    expect(m.distance).to eql(nil)
    m.set_tentative_distance(10)
    expect(m.distance).to eql(10)
    m.set_tentative_distance(8)
    expect(m.distance).to eql(8)
    m.set_tentative_distance(18)
    expect(m.distance).to eql(8)
  end

  it 'visits' do
    m = MapPoint.new(0, 0, 5)
    expect(m.visited).to eql(false)
    m.visit
    expect(m.visited).to eql(true)
  end

  # it 'gets next' do
  #   m1 = MapPoint.new(0, 0, 5)
  #   m2 = MapPoint.new(1, 0, 5)
  #   m3 = MapPoint.new(0, 1, 5)
  #   m4 = MapPoint.new(1, 1, 5)

  #   m1.add_neighbor(m2)
  #   m1.add_neighbor(m3)
  #   m1.add_neighbor(m4)

  #   m2.set_tentative_distance(20)
  #   m3.set_tentative_distance(30)
  #   m4.set_tentative_distance(40)

  #   expect(m1.get_next[0]).to eql(m2)
  #   m2.visit
  #   expect(m1.get_next[0]).to eql(m3)
  #   m3.set_tentative_distance(20)
  #   m4.set_tentative_distance(20)
  #   expect(m1.get_next.length).to eql(2)
  #   expect(m1.get_next[0]).to eql(m3)
  #   expect(m1.get_next[1]).to eql(m4)

  # end
end

describe ElevationMap do
  it 'finds shortest distance on a map' do
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

    puts "finding distance"
    m = MapBuilder.from_strings(s)
    m.compute_path
    expect(m.end.distance).to eql(31)
  end

  it 'finds the shortest trail on a map' do
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

    puts "finding distance"
    maps = TrailBuilder.from_strings(s)
    min = 100000
    maps.each do |m|
      m.compute_path
      min = m.end.distance if(m.end.distance < min)
    end
    puts min
  end
end
