$grounded = true

class Point
  attr_accessor :x
  attr_accessor :y
  def initialize(x,y)
    @x = x
    @y = y
  end
end

class Underground
  attr_reader :map

  def initialize(rock_locations, entry_point)
    @width = rock_locations.map {|r| r.x }.max + 1
    @height = rock_locations.map {|r| r.y }.max + 1
    @entry_point = entry_point
    @debug = false

    puts "creating map with width #{@width} and height #{@height}" if @debug

    @map = Array.new(@width) { Array.new(@height, :empty) }

    rock_locations.each { |r| @map[r.x][r.y] = :rock }
  end

  def count_til_overflow
    counter = 0

    while add_sand != :overflow
      counter += 1
    end

    counter+1
  end

  def count_sand
    counter = 0

    while add_sand
      counter += 1
    end

    counter
  end

  def add_sand()
    n = next_sand_location(@entry_point, 0)
    return :overflow if n.nil?
    puts "adding..." if @debug
    prev = n
    until(n.nil?) do
      prev = n
      return false if n == :abyss
      n = next_sand_location(n.x, n.y)
    end
    puts "setting sand at #{prev.x},#{prev.y}" if @debug
    @map[prev.x][prev.y] = :sand
    return true
  end

  def get_material_at(x,y)
    return :abyss if y >= @height
    return nil if x < 0 || y < 0
    return nil if x >= @width

    map[x][y]
  end

  def next_sand_location(x, y)
    if(get_material_at(x,y+1) == :abyss)
      puts "abyss @ #{x},#{y+1}" if @debug
      return :abyss
    elsif(get_material_at(x,y+1) == :empty)
      puts "down to #{x},#{y+1}" if @debug
      return Point.new(x, y+1)
    elsif(get_material_at(x-1, y+1) == :empty)
      puts "down+left to@ #{x-1},#{y+1}" if @debug
      return Point.new(x-1, y+1)
    elsif(get_material_at(x+1, y+1) == :empty)
      puts "down+right to #{x+1},#{y+1}" if @debug
      return Point.new(x+1, y+1)
    end
    puts 'nothing' if @debug
    return nil
  end

  def print(start_x = 0, start_y = 0)
    (start_y..@height - 1).each do |y|
      row = []
      (start_x..@width - 1).each do |x|
        chr = '.'
        chr = '#' if @map[x][y] == :rock
        chr = 'o' if @map[x][y] == :sand
        chr = 'E' if @entry_point == x && y == 0
        row.push(chr)
      end
      puts "#{y} | #{row.join(' ')} |"
    end
    #puts "  |#{Array.new(@width, '_')}|"
  end
end


class MapBuilder
  def self.from_file(file)
    lines = []
    File.foreach("./scan") { |line| lines.push(line) }
    build(lines)
  end

  def self.build(lines)
    paths = []
    height = 0
    width = 0

    lines.each do |l|
      path = []
      l.split('->').each do |p|
        coords = p.strip.split(',').map {|i| i.strip.to_i}
        point = Point.new(coords[0], coords[1])
        path.push(point)
        height = point.y if point.y > height
        width = point.x if point.x > width
      end
      paths.push(path)
    end

    rocks = []

    paths.each do |path|
      (0..path.length-2).each do |i|
        p1 = path[i]
        p2 = path[i+1]

        raise 'NO DIAG' if(p1.x != p2.x && p1.y != p2.y)

        if(p1.x != p2.x)
          y = p1.y
          if(p1.x > p2.x)
            (p2.x..p1.x).each do |x|
              rocks.push(Point.new(x,y))
            end
          else
            (p1.x..p2.x).each do |x|
              rocks.push(Point.new(x,y))
            end
          end
        else
          x = p1.x
          if(p1.y > p2.y)
            (p2.y..p1.y).each do |y|
              rocks.push(Point.new(x,y))
            end
          else
            (p1.y..p2.y).each do |y|
              rocks.push(Point.new(x,y))
            end
          end
        end
      end
    end

    puts "HEIGHT: #{height} WIDTH: #{width}"
    (0..width+200).each{|x| rocks.push(Point.new(x,height+2)) } if $grounded

    Underground.new(rocks, 500)
  end
end
