require './distance_computer'

class Valve 
  attr_reader :name
  attr_reader :flow
  attr_reader :neighbors
  attr_reader :opened_at

  def initialize(name, flow, neighbors)
    @name = name
    @flow = flow
    @neighbors = neighbors
    @opened_at = nil
  end

  def attach(valve_system)
    @system = valve_system
  end

  def distance_to(valve)
    return nil if @system.nil?
    @system.get_distance(@name, valve.name)
  end

  def open(now)
    @opened_at = now
  end

  def is_open?
    !@opened_at.nil?
  end
end

class ValveSystem
  attr_reader :valves

  def initialize(valves, starting_valve)
    @valves = valves  
    @valves.each{ |v| v.attach(self) }
    @distances = compute_distances
    @starting_valve = starting_valve
  end

  def compute_distances
    computer = DistanceComputer.new(@valves)
    distances = {}
    @valves.each { |v| distances[v.name] = {}}
    @valves.each do |from_valve|
      from = from_valve.name
      @valves.each do |to_valve|
        to = to_valve.name
        if from == to 
          distances[from][to] = 0 
          next
        end
        if !distances[to][from].nil?
          distances[from][to] = distances[to][from] 
          next
        end
        distances[from][to] = computer.compute(from, to)
      end
    end
    distances
  end

  def print_distances
    @distances.each do |from, tos|
      tos.each { |to, d| puts "#{from} -> #{to}: #{d}"}
    end
  end

  def get_distance(from, to)
    return nil if @distances[from].nil?
    @distances[from][to]
  end
end