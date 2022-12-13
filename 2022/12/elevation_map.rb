class MapPoint
  attr_accessor :x
  attr_accessor :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def ==(p)
    (@x == p.x) && (@y == p.y)
  end

  def to_s
    "#{@x},#{@y}"
  end
end

class PersonLocation
  attr_accessor :x
  attr_accessor :y
  attr_reader :path
  attr_reader :history

  def initialize(x, y, path=[])
    @x = x
    @y = y
    @path = path
  end

  def ==(p)
    (@x == p.x) && (@y == p.y)
  end

  def move(direction)
    x = @x
    y = @y
    case (direction)
      when :up
        y -= 1
      when :down
        y += 1
      when :left
        x -= 1
      when :right
        x += 1
    end

    if(@path.include?(MapPoint.new(x, y)))
      #puts "  no backtracking."
      return nil
    else
      path = [].concat(@path)
      path.push(self)

      puts "Moving #{direction} from #{@x},#{@y} to #{x},#{y}"
      return PersonLocation.new(x, y, path)
    end
  end

  def visited?(direction)
    x = @x
    y = @y
    case (direction)
      when :up
        y -= 1
      when :down
        y += 1
      when :left
        x -= 1
      when :right
        x += 1
    end
    return @path.include?(MapPoint.new(x, y))
  end

  def backtrack
    return if @path.length == 0
    last = @path.pop()
    @x = last.x
    @y = last.y
    #puts "backtracked to #{@x},#{@y}"
  end
end


# x,y #############
# 0,0          5,0#
#                 #
#                 #
#                 #
# 0,5          5,5#
###################

class ElevationMap
  attr_reader :viable_paths
  attr_reader :map
  attr_reader :current
  attr_reader :end

  def initialize(start_point, end_point, map)
    @current = PersonLocation.new(start_point.x, start_point.y)
    @end = end_point
    @map = map
    @width = map.length
    @height = map[0].length
    @viable_paths = []
    @visited = Array.new(@width, Array.new(@height, 100000))
    puts "#{start_point.x}, #{start_point.y}"
  end

  def navigate(direction)
    current =  @current.move(direction)
    #puts "new : #{@current.x}, #{@current.y}"
    return if current.nil?
    return if @visited[current.x][current.y] < current.path.length
    puts 'navigated'
    @current = current
    @visited[@current.x][@current.y] = @current.path.length


    if is_at_end?
      #puts "Found end @ #{@current.x},#{@current.y}: #{@current.path.map{|x| x.to_s}}"
      @viable_paths.push(@current)
      return
    end

    explore
  end

  def explore
    options = movement_options
    #puts "Exploring from #{@current.x},#{@current.y} (#{map[@current.x][@current.y].chr}): #{options} (#{options.length})"
    return if options.length == 0

    current = @current
    options.each do |m|
      navigate(m)
      @current = current
    end
  end

  def get_shortest_path_length
    shortest = 1000000
    @viable_paths.each do |p|
      shortest = p.path.length if p.path.length < shortest
    end
    shortest
  end

  def movement_options
    directions = []
    directions.push(:right) if can_move_right?
    directions.push(:up) if can_move_up?
    directions.push(:down) if can_move_down?
    directions.push(:left) if can_move_left?
    directions
  end

  def is_at_end?
    @current == @end
  end

  def can_move_up?
    return false if @current.y <= 0
    return false if @current.visited?(:up)
    current_elevation = @map[@current.x][@current.y]
    next_elevation = @map[@current.x][@current.y - 1]
    (current_elevation + 1) >= next_elevation
  end

  def can_move_down?
    return false if @current.y >= (@height - 1)
    return false if @current.visited?(:down)
    current_elevation = @map[@current.x][@current.y]
    next_elevation = @map[@current.x][@current.y + 1]
    (current_elevation + 1) >= next_elevation
  end

  def can_move_left?
    return false if @current.x <= 0
    return false if @current.visited?(:left)
    current_elevation = @map[@current.x][@current.y]
    next_elevation = @map[@current.x - 1][@current.y]
    (current_elevation + 1) >= next_elevation
  end

  def can_move_right?
    return false if @current.x >= (@width - 1)
    return false if @current.visited?(:right)
    current_elevation = @map[@current.x][@current.y]
    next_elevation = @map[@current.x + 1][@current.y]
    (current_elevation + 1) >= next_elevation
  end


  def self.parse_map_string(map_string)
    [MapPoint.new(0,0), MapPoint.new(5,5), []]
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
          start_point = MapPoint.new(x,y)
          c = 'a'
        elsif(c == 'E')
          end_point = MapPoint.new(x,y)
          c = 'z'
        end
        row.push(c.ord)
      end
      translated.push(row)
    end
    ElevationMap.new(start_point, end_point, translated)
  end
end
