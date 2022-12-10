class KnotPosition
  attr_accessor :x
  attr_accessor :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def is_adjacent_to?(pos)
    return true if (@x - pos.x).abs() <= 1 && (@y - pos.y).abs() <= 1
    false
  end

  #If the head is ever two steps directly up, down, left, or right from the tail, the tail must also move one step in that direction so it remains close enough:
  #Otherwise, if the head and tail aren't touching and aren't in the same row or column, the tail always moves one step diagonally to keep up:
  def move_adjacent_to(pos)
    return if is_adjacent_to?(pos)

    x_distance = pos.x - @x
    y_distance = pos.y - @y

    if(x_distance != 0)
      @x -= 1 if x_distance.negative?
      @x += 1 unless x_distance.negative?
    end

    if(y_distance != 0)
      @y -= 1 if y_distance.negative?
      @y += 1 unless y_distance.negative?
    end
  end

  def is_at(x,y)
    @x == x && @y == y
  end

  def to_s
    "x: #{x}, y: #{@y}"
  end
end

class RopeBridge
  attr_reader :tail_tracker
  attr_reader :rope_map
  attr_reader :head
  attr_reader :knots
  attr_reader :tail

  def initialize(width,height,knot_count)
    @tail_tracker = Array.new(width)
    (0..width).each{ |x| @tail_tracker[x] = Array.new(height, false) }

    @knots = Array.new(knot_count)
    (0..knot_count-1).each{ |i| @knots[i] = KnotPosition.new(width / 2, height / 2) }
    @head = @knots[0]
    @tail = @knots[knot_count - 1]
  end

  def move(str)
    directions = {
      'R' => :right,
      'U' => :up,
      'L' => :left,
      'D' => :down
    }
    #puts str
    parts = str.split(' ')
    move_head(directions[parts[0].strip], parts[1].to_i)
  end

  def move_head(direction, n)
    while(n > 0) do
      move_head_by_1(direction)
      n -= 1
    end
    #print
  end

  def move_head_by_1(direction)
    x = @head.x
    y = @head.y
    case direction
      when :up
        @head.y -= 1
      when :down
        @head.y += 1
      when :left
        @head.x -= 1
      when :right
        @head.x += 1
    end
    move_knot(0)
  end

  def tail_visited_count
    i = 0
    @tail_tracker.each do |x|
      x.each do |y|
        i += 1 if y
      end
    end
    i
  end

  def get_marker_for(x,y)
    matches = []

    (0..knots.length - 1).each do |i|
      #puts "#{knots[i].to_s} #{x},#{y}"
      matches.push(i) if knots[i].is_at(x, y)
    end
    if(matches.include?(0))
      return 'H'
    elsif(matches.include?(knots.length-1))
        return 'T'
    elsif(matches.length == 1)
      return matches[0].to_s
    elsif(matches.length > 1)
      return 'M'
    else
      return ' '
    end
  end

  def print
    return
    n = @tail_tracker.length
    puts ""
    puts Array.new(n+3, "#").join("")
    (0..n).each do |y|
      row = []
      (0..n).each do |x|
        row.push(get_marker_for(x,y))
      end
      puts "##{row.join("")}# #{y}"
    end
    puts "#{Array.new(n+3, "#").join("")}"
    puts " #{(0..n).map { |x| x / 10}.join("")} "
    puts " #{(0..n).map { |x| x % 10}.join("")} "
    puts ""
  end

  def move_knot(n)
    curr = @knots[n]
    if(curr == @tail)
      @tail_tracker[@tail.x][@tail.y] = true
      return
    end

    nxt = @knots[n+1]
    x = nxt.x
    y = nxt.y
    begin
      nxt.move_adjacent_to(curr)
    rescue => err
      puts "error moving knot #{n+1}(#{x},#{y}): #{err}"
      print
      raise err
    end
    print
    move_knot(n+1)
  end
end
