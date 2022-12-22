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

describe InputParser do
  it 'parses valve line' do
    parser = InputParser.new
    valve = parser.parse('Valve AA has flow rate=40; tunnels lead to valves DD, II, BB')
    expect(valve.name).to eq('AA')
    expect(valve.flow).to eq(40)
    expect(valve.neighbors.length).to eq(3)
    expect(valve.neighbors.include?('DD')).to eq(true)
    expect(valve.neighbors.include?('II')).to eq(true)
    expect(valve.neighbors.include?('BB')).to eq(true)
    expect(valve.neighbors.include?('AA')).to eq(false)
  end
  it 'parses lines' do
    parser = InputParser.new
    valves = parser.parse_lines(test_input)
    expect(valves.length).to eql(10)
  end
end