require 'set'

class PathGenerator
  def initialize(valves, max_time)
    @valves = {}
    valves.each { |v| @valves[v.name] = v }
    @max_time = max_time
  end

  def generate(start)
    to_visit = [start]
    current_time = 0 
    path = []

    while(to_visit.length > 0)
      current = to_visit.shift
      puts "Visting: #{current.name}, path: #{path.map{|x| x.name}.join(',')}"
      path.push(current)

      @valves.each do |v|
        next if path.include?(v)
        path.push(v)
      end

      yield path if(@valves.length == path.length)

      
      # yield path if current.neighbors.count { |x| !path.include?(@valves[x])} == 0

      # current.neighbors.each do |n|
      #   valve = @valves[n]
      #   to_visit.unshift(valve) unless path.include?(valve)
      # end
      
    end
  end
end