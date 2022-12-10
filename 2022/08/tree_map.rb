
class TreeMap
  attr_reader :map
  def initialize(lines)
    @map = []  #y, x
    lines.each do |l|
      row = []
      n = 0
      l.split('').each do |x|
        row.push(x.to_i) unless x.strip.empty?
      end
      @map.push(row)
    end
  end

  def is_taller_than_all?(n, others)
    others.each do |x|
      if(n <= x)
        return false
      end
    end
    true
  end

  def is_visible_from_top?(x, y)
    n = map[y][x]
    others = []
    (0..y-1).each do |i|
      others.push(map[i][x])
    end
    #puts "#{x},#{y} - #{n}: #{others}"
    is_taller_than_all?(n, others)
  end

  def is_visible_from_bottom?(x, y)
    n = map[y][x]
    others = []

    (y+1..map.length-1).each do |i|
      others.push(map[i][x])
    end

    is_taller_than_all?(n, others)
  end

  def is_visible_from_left?(x, y)
    n = map[y][x]
    others = []
    others = map[y][0..x-1] unless x == 0

    is_taller_than_all?(n, others)
  end

  def is_visible_from_right?(x, y)
    n = map[y][x]
    others = map[y][x+1..map[y].length-1]

    is_taller_than_all?(n, others)
  end

  def get_visibility_matrix
    visible = []
    (0..map.length-1).each do |y|
      current = []
      visible.push(current)
      (0..map[y].length-1).each do |x|
        if(is_visible_from_top?(x,y))
          current.push('Y')
        elsif(is_visible_from_bottom?(x,y))
          current.push('Y')
        elsif(is_visible_from_left?(x,y))
          current.push('Y')
        elsif(is_visible_from_right?(x,y))
          current.push('Y')
        else
          current.push('N')
        end
      end
    end
    visible
  end

  def get_visible_count
    m = get_visibility_matrix
    count = 0
    m.each do |x|
      x.each do |y|
        count += 1 if y == "Y"
      end
    end
    count
  end

  def print_visibility_matrix
    puts ""
    get_visibility_matrix.each do |x|
      puts "#{x.join("")}"
    end
  end

  def get_directional_scenic_score(n, others)
    score = 0
    others.each do |x|
      score += 1
      if(n <= x)
        return score
      end
    end
    score
  end

  def get_scenic_score_up(x, y)
    n = map[y][x]
    others = []
    (0..y-1).each do |i|
      others.push(map[i][x])
    end
    others = others.reverse
    get_directional_scenic_score(n, others)
  end

  def get_scenic_score_down(x, y)
    n = map[y][x]
    others = []

    (y+1..map.length-1).each do |i|
      others.push(map[i][x])
    end
    get_directional_scenic_score(n, others)
  end

  def get_scenic_score_left(x, y)
    n = map[y][x]
    others = []
    others = map[y][0..x-1].reverse unless x == 0
    get_directional_scenic_score(n, others)
  end

  def get_scenic_score_right(x, y)
    n = map[y][x]
    others = map[y][x+1..map[y].length-1]
    get_directional_scenic_score(n, others)
  end


  def calculate_scenic_score(x,y)
    up = get_scenic_score_up(x, y)
    down = get_scenic_score_down(x, y)
    left  = get_scenic_score_left(x, y)
    right = get_scenic_score_right(x, y)
    #puts "up: #{up} down: #{down} left: #{left} right: #{right}"
    up * down * left * right
  end

  def get_best_scenic_score
    best = 0
    best_location = "
    "
    (0..map.length-1).each do |y|
      (0..map[y].length-1).each do |x|
        score = calculate_scenic_score(x,y)
        if(score > best)
          best = score
          best_location = "#{x},#{y}"
        end
      end
    end
    [best, best_location]
  end
end
