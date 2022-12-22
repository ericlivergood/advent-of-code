require './valve_system'
require './input_parser'

test_input = [
  'Valve AA has flow rate=0; tunnels lead to valves DD, II, BB',
  'Valve BB has flow rate=13; tunnels lead to valves CC, AA',
  'Valve CC has flow rate=2; tunnels lead to valves DD, BB',
  'Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE',
  'Valve EE has flow rate=3; tunnels lead to valves FF, DD',
  'Valve FF has flow rate=0; tunnels lead to valves EE, GG',
  'Valve GG has flow rate=0; tunnels lead to valves FF, HH',
  'Valve HH has flow rate=22; tunnel leads to valve GG',
  'Valve II has flow rate=0; tunnels lead to valves AA, JJ',
  'Valve JJ has flow rate=21; tunnel leads to valve II'
]

describe Valve do
  it 'opens' do
    v = Valve.new(nil, nil, nil)
    expect(v.opened_at).to eql(nil)
    expect(v.is_open?).to eql(false)
    
    v.open(20)
    expect(v.opened_at).to eql(20)
    expect(v.is_open?).to eql(true)
  end

  it 'gets distance' do
    v = Valve.new(nil, nil, nil)
    v2 = Valve.new(nil, nil, nil)

    test_system = Object.new
    def test_system.get_distance(from, to)
        100
    end
    v.attach(test_system)
    expect(v.distance_to(v2)).to eql(100)
  end

  it 'returns nil for distances if not attached' do
    v = Valve.new(nil, nil, nil)
    v2 = Valve.new(nil, nil, nil)
    expect(v.distance_to(v2)).to eql(nil)
  end
end

describe ValveSystem do
  it 'provides distances to valves' do
    valves = InputParser.new.parse_lines(test_input)
    aa = valves.filter{ |v| v.name == "AA" }[0]
    jj = valves.filter{ |v| v.name == "JJ" }[0]
    ff = valves.filter{ |v| v.name == "FF" }[0]
    
    s = ValveSystem.new(valves, aa)
    expect(aa.distance_to(aa)).to eql(0)
    expect(aa.distance_to(jj)).to eql(2)
    expect(aa.distance_to(ff)).to eql(3)
  end
end