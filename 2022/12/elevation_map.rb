class MapPoint
  attr_reader :x
  attr_reader :y
  attr_reader :height
  attr_reader :neighbors
  attr_reader :visited
  attr_reader :distance

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
    @neighbors = []
    @visited = false
    @distance = nil
  end

  def add_neighbor(p)
    @neighbors.push(p) if (p.height + 1) >= @height
  end

  def ==(p)
    (@x == p.x) && (@y == p.y)
  end

  def to_s
    "#{@x+1},#{@y+1} | visited: #{@visited} | height: #{@height.chr} | distance: #{@distance} | neighbors: #{@neighbors.length}"
  end

  def set_tentative_distance(distance)
    @distance = distance if (@distance.nil? || distance < @distance) && !@visited
  end

  def visit
    #puts "Visited: #{self}"
    @visited = true
  end

  def get_next
    shortest = @neighbors.filter{|x| !x.visited }.sort_by {|x| x.distance}[0]
    return [] if shortest.nil?
    unvisited = @neighbors.filter{|x| x.distance == shortest.distance && !x.visited}
    unvisited[0]
  end
end


# # x,y #############
# # 0,0          5,0#
# #                 #
# #                 #
# #                 #
# # 0,5          5,5#
# ###################

class ElevationMap
  attr_reader :all_points
  attr_reader :map
  attr_reader :current
  attr_reader :end

  def initialize(start_point, end_point, map)
    @width = map.length
    @height = map[0].length
    @all_points = []
    init_map(map)
    add_neighbors
    @current = @map[start_point.x][start_point.y]
    @current.set_tentative_distance(0)
    @end = @map[end_point.x][end_point.y]
    @optimal_path = []
  end

  def init_map(map)
    @map = Array.new(@width)
    (0..@width - 1).each{ |x| @map[x] = Array.new(@height, nil) }

    (0..@width - 1).each do |x|
      (0..@height - 1).each do |y|
        p = MapPoint.new(x, y, map[x][y])
        @map[x][y] = p
        @all_points.push(p)
      end
    end
  end

  def add_neighbors
    map = @map
    (0..@width - 1).each do |x|
      (0..@height - 1).each do |y|
        map[x][y].add_neighbor(map[x + 1][y]) unless x >= (@width - 1)
        map[x][y].add_neighbor(map[x][y + 1]) unless y >= (@height - 1)
        map[x][y].add_neighbor(map[x][y - 1]) unless y <= 0
        map[x][y].add_neighbor(map[x - 1][y]) unless x <= 0
      end
    end
  end

  def print
    (0..@height - 1).each do |y|
      row = []
      (0..@width - 1).each do |x|
        row.push(@map[x][y].height.chr)
      end
      puts row.join
    end
  end

  def get_next_unvisited
    @all_points.filter{|x| !x.visited && !x.distance.nil? }.sort_by {|x| x.distance}[0]
  end

  def compute_path
    loop do
      distance = @current.distance + 1
      @current.neighbors.each do |n|
        n.set_tentative_distance(distance)
      end
      @current.visit
      @current = get_next_unvisited
    break if @current.nil? || @current.height.chr == 'a'
    end
    @end = @current
  end
end

class MapBuilder
  def self.from_file(file)
    str = File.read(file)
    from_strings(str)
  end

  def self.from_strings(str)
    lines = str.strip.split("\n").map {|s| s.strip }
    height = lines.length
    width = lines[0].strip.length
    translated = []
    start_point = nil
    end_point = nil

    (0..width - 1).each do |x|
      row = []
      (0..height - 1).each do |y|
        c = lines[y][x]
        next if c.empty?
        if(c == 'S')
          start_point = MapPoint.new(x,y,nil)
          c = 'a'
        elsif(c == 'E')
          end_point = MapPoint.new(x,y,nil)
          c = 'z'
        end
        row.push(c.ord)
      end
      translated.push(row)
    end
    ElevationMap.new(end_point, end_point, translated)
  end
end


class TrailBuilder
  def self.from_file(file)
    str = File.read(file)
    from_strings(str)
  end

  def self.from_strings(str)
    lines = str.strip.split("\n").map {|s| s.strip }
    height = lines.length
    width = lines[0].strip.length
    translated = []
    start_points = []
    end_point = nil

    (0..width - 1).each do |x|
      row = []
      (0..height - 1).each do |y|
        c = lines[y][x]
        next if c.empty?
        if(c == 'S')
          c = 'a'
        elsif(c == 'E')
          end_point = MapPoint.new(x,y,nil)
          c = 'z'
        end

        if(c == 'a')
          start_points.push(MapPoint.new(x,y,nil))
        end
        row.push(c.ord)
      end
      translated.push(row)
    end
    maps = []
    puts "starts: #{start_points.length}"
    n = 1
    start_points.each do |s|
      puts "Assembling #{n}"
      maps.push(ElevationMap.new(s, end_point, translated))
      n+=1
    end
    maps
  end
end
