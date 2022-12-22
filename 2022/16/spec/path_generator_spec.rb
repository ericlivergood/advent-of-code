require './path_generator'


describe PathGenerator do
  it 'generates basic path' do 
    #valve_a = Valve.new('A', nil, ['B', 'E', 'F'])
  
    valve_a = Valve.new('A', nil, ['B'])
    valves = [
      valve_a,
      Valve.new('B', nil, ['A', 'C']),
      Valve.new('C', nil, ['B'])
      # Valve.new('B', nil, ['A', 'H', 'C']),
      # Valve.new('C', nil, ['B', 'D', 'I']),
      # Valve.new('D', nil, ['C', 'G']),
      # Valve.new('E', nil, ['A', 'G']),
      # Valve.new('F', nil, ['A']),
      # Valve.new('G', nil, ['E']),
      # Valve.new('H', nil, ['B']),
      # Valve.new('I', nil, ['C']),
    ]
    valve_system = ValveSystem.new(valves, valve_a)

    gen = PathGenerator.new(valves, 30)
    gen.generate(valve_a) do |p|
      puts "GENERATED: #{p.map{|x| x.name}.join(",")}"
    end
  end
end