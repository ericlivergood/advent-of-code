require './distance_computer'

describe DistanceComputer do
  it 'computes trivial distance' do
    valves = [
      Valve.new('A', nil, ['B']),
      Valve.new('B', nil, ['A', 'C']),
      Valve.new('C', nil, ['B'])
    ]
    c = DistanceComputer.new(valves)
    expect(c.compute('A', 'A')).to eql(0)
    expect(c.compute('B', 'B')).to eql(0)
    expect(c.compute('C', 'C')).to eql(0)

    expect(c.compute('A', 'B')).to eql(1)
    expect(c.compute('A', 'C')).to eql(2)

    expect(c.compute('B', 'C')).to eql(1)
    expect(c.compute('B', 'A')).to eql(1)

    expect(c.compute('C', 'A')).to eql(2)
    expect(c.compute('C', 'B')).to eql(1)
  end

  it 'computes test input distances' do
    valves = [
      Valve.new('AA', nil, ['DD', 'II', 'BB']),
      Valve.new('BB', nil, ['CC', 'AA']),
      Valve.new('CC', nil, ['DD', 'BB']),
      Valve.new('DD', nil, ['CC', 'AA', 'EE']),
      Valve.new('EE', nil, ['FF', 'DD']),
      Valve.new('FF', nil, ['EE', 'GG']),
      Valve.new('GG', nil, ['FF', 'HH']),
      Valve.new('HH', nil, ['GG']),
      Valve.new('II', nil, ['AA', 'JJ']),
      Valve.new('JJ', nil, ['II']),
    ]
    c = DistanceComputer.new(valves)
    expect(c.compute('AA', 'BB')).to eql(1)
    expect(c.compute('AA', 'CC')).to eql(2)
    expect(c.compute('AA', 'DD')).to eql(1)
    expect(c.compute('AA', 'EE')).to eql(2)
    expect(c.compute('AA', 'FF')).to eql(3)
    expect(c.compute('AA', 'GG')).to eql(4)
    expect(c.compute('AA', 'HH')).to eql(5)
    expect(c.compute('AA', 'II')).to eql(1)
    expect(c.compute('AA', 'JJ')).to eql(2)

    expect(c.compute('HH', 'JJ')).to eql(7)
    expect(c.compute('JJ', 'CC')).to eql(4)
  end
end