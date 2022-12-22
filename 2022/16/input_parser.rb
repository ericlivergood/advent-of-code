require './valve_system'

class InputParser
  def parse_file(file)
    lines = []
    File.foreach("./input") { |line| lines.push(eval(line)) }
    parse_lines(lines)
  end

  def parse_lines(lines)
    lines.map{ |l| parse(l) }
  end

  def parse(line)
    parts = line.strip.split(';')
    valve_parts = parts[0].split(' has flow rate=')
    name = valve_parts[0].sub('Valve', '').strip
    flow = valve_parts[1].strip.to_i

    neighbors = parts[1]
      .sub('tunnels lead to valves', '')
      .sub('tunnel leads to valve', '')
      .split(',')
      .map { |p| p.strip }

    #puts "#{name}: #{flow}, #{neighbors}"
    Valve.new(name, flow, neighbors)
  end
end