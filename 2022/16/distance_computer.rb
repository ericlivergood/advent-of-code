require 'set'
require './valve_system'

class DistanceComputer
  def initialize(valves)
    @valves = {}
    valves.each{ |v| @valves[v.name] = v}
  end

  def compute(from, to)
    #puts "Computing #{from} to #{to}"
    return 0 if from == to
    
    current_distance = 0
    current = @valves[from]
    end_valve = @valves[to]

    distances = {}
    @valves.values.each{ |v| distances[v.name] = 9999 }
    distances[from] = 0
    #puts "Init: #{distances}"

    visited = Set.new([current])

    loop do 
      current_distance = distances[current.name]
      #puts "Current #{current.name} | distance: #{current_distance}"
      current.neighbors.each do |n|
        if(distances[n].nil?)
          raise "Wat? #{n}"
        end
        distances[n] = current_distance + 1 unless distances[n] < current_distance + 1
      end
      #puts "Distances: #{distances}"
      visited.add(current.name)
      #break if current == end_valve
      current = @valves
        .values
        .filter { |v| !visited.include?(v.name)}
        .sort_by { |x| distances[x.name]}[0]
      #puts "Next: #{current.nil? ? 'nil' : current.name}"
      break if current.nil? 
    end
    distances[to]
  end
end