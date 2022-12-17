require 'set'
require 'time'

class Point
  attr_reader :x
  attr_reader :y

  def initialize(x,y)
    @x = x
    @y = y
  end

  def ==(p)
    (@x == p.x) && (@y == p.y)
  end
end
class Thing < Point
  def initialize(x,y)
    super(x,y)
  end

  def distance_to(thing)
    (@x - thing.x).abs + (@y - thing.y).abs
  end

  def find_closest_thing(things)
    closest = nil
    closest_distance = nil

    things.each do |t|
      distance = distance_to(t)
      if(closest.nil? || distance < closest_distance)
        closest = t
        closest_distance = distance_to(closest)
      end
    end

    closest
  end
end

class Beacon < Thing
end

class Sensor < Thing
  attr_reader :closest_beacon

  def initialize(x, y, beacons)
    super(x,y)
    @closest_beacon = find_closest_thing(beacons)
    @beacon_distance = distance_to(@closest_beacon)
  end

  def get_beaconless_area(row = nil)
    distance = distance_to(@closest_beacon)
    beaconless = []
    y = row
    #puts "from #{@x - distance} to #{@x + distance}"
    (@x - distance..@x + distance).each do |x|
      (@y - distance..@y + distance).each do |y|
        next unless row == y || row.nil?
        point = Point.new(x, y)
        beaconless.push(point) if distance_to(point) <= distance unless point == @closest_beacon
      end
    end

    beaconless
  end

  def get_beaconless_row_points(row)
    return [] if(row < (@y - @beacon_distance) || row > (@y + @beacon_distance))

    y_delta = (y - row).abs
    length = (@beacon_distance - y_delta)

    xs=[]
    #puts "#{-1 * length + @x} to #{length + @x} "
    (-1 * length  + @x.. length + @x).each do |i|
      xs.push(i) unless @closest_beacon.x == i && @closest_beacon.y == row
    end
    xs
  end

  def get_beaconless_ranges(max)
    (0..max).each do |y|
      next if(y < (@y - @beacon_distance) || y > (@y + @beacon_distance))
      y_delta = (y - @y).abs
      length = (@beacon_distance - y_delta).abs

      range_start = @x - length
      range_start = 0 if range_start < 0
      range_start = max if range_start > max

      range_end = length + @x
      range_end = 0 if range_end < 0
      range_end = max if length + @x > max

      yield y,(range_start..range_end)
    end
  end
end

class InputParser
  def self.parse(lines)
    beacons = []
    sensors = []

    lines.each do |l|
      sensor,beacon = parse_line(l)
      beacons.push(beacon)
      sensors.push(sensor)
    end

    Tunnels.new(sensors,beacons)
  end

  def self.parse_line(line)
    parts = line.split(': ')

    sensor_parts = parts[0].split(', ')
    sensor_x = sensor_parts[0].sub('Sensor at x=', '').to_i
    sensor_y = sensor_parts[1].sub('y=', '').to_i

    beacon_parts = parts[1].split(', ')
    beacon_x = beacon_parts[0].sub('closest beacon is at x=', '').to_i
    beacon_y = beacon_parts[1].sub('y=', '').to_i

    beacon = Beacon.new(beacon_x, beacon_y)
    sensor = Sensor.new(sensor_x, sensor_y, [beacon])
    return sensor,beacon
  end
end

class Tunnels
  def initialize(sensors, beacons)
    @sensors = sensors
    @beacons = beacons
    #@map = populate_map
  end

  def self.ranges_overlap?(a, b)
    return true if a.begin == b.begin || a.end == b.end
    a_begin = a.begin - 1
    a_begin = 0 if a_begin < 0

    b_begin = b.begin - 1
    b_begin = 0 if b_begin < 0

    a.include?(b_begin) || b.include?(a_begin)
  end

  def self.combine_ranges(a, b)
    min = [a.min, b.min].min
    max = [a.max, b.max].max

    (min..max)
  end

  def self.debug(str)
    #puts str
  end

  def self.combine_range_set(ranges)
    combined = true
    already_combined = Set.new
    n = 0
    while(ranges.length > 1 && n < 400 && combined)
      combined = false
      n += 1
      working = Set.new
      # debug('')
      # debug("n: #{n}")
      # debug("ranges: #{ranges}")
      ranges.each do |r1|
        ranges.each do |r2|
          #debug('')
          #debug "examining #{r1},#{r2}"
          next if r1 == r2
          #next if already_combined.include?(r1)
          #next if already_combined.include?(r2)
          # debug "trying #{r1},#{r2}"
          if(ranges_overlap?(r1, r2))
            combined = true
            new_range = combine_ranges(r1, r2)
            # debug "combining #{r1}, #{r2} |new: #{new_range} | working set: #{working} | already combined: #{already_combined}"
            working.add(new_range)
            working.delete(r1) unless new_range == r1
            working.delete(r2) unless new_range == r2
            already_combined.add(r1) unless new_range == r1
            already_combined.add(r2) unless new_range == r2
            # debug "combined #{r1}, #{r2} | working set: #{working} | already combined: #{already_combined}"
          else
            working.add(r1) unless already_combined.include?(r1) || working.include?(r1)
            working.add(r2) unless already_combined.include?(r2) || working.include?(r2)
            # debug "cant combine #{r1}, #{r2} | working set: #{working} | already combined: #{already_combined}"
          end
        end
      end
      #debug "ranges: #{ranges}, working #{working}, already combined: #{already_combined}"
      #debug ""
      ranges = working.to_a
    end
    #debug("COMBINED: #{ranges.sort_by{|x| x.begin}}")
    ranges
  end

  def has_gap_in_ranges(ranges, max_value)
    ranges = ranges.sort_by {|r| r.min}
    return true if ranges[0].min != 0
    return false

    (0..max_value).each do |n|
      found = false
      r = 0
      while(r < ranges.length && !found)
        found = true if ranges[r].include?(n)
        r += 1
      end
      return n if !found
    end

    false
  end

  def find_distress_beacon(max_range)
    rows = Array.new(max_range+1) { [] }
    puts 'getting ranges'
    @sensors.each do |s|
      puts "sensor #{s}"
      s.get_beaconless_ranges(max_range) do |y,r|
        rows[y].push(r)
      end
      rows[s.y].push((s.x..s.x)) unless s.x > max_range
    end

    @beacons.each do |b|
      rows[b.y].push((b.x..b.x)) unless rows[b.y].nil? || b.x > max_range
    end

    puts "finding gaps"
    # (0..max_range-1).each do |i|
    #   puts i if i % 100000 == 0
    #   r = rows[i]
    #   gap = has_gap_in_ranges(r, max_range)
    #   next if !gap

    #   return Point.new(gap,i)
    # end
    n = 0
    rows.each do |r|
      n+=1
      next if n < 3204000 || n > 3205000
      puts "#{Time.now}: #{n} - #{r}" if n % 10000 == 0
      combined = self.class.combine_range_set(r)
      puts "FOUND y:#{n-1}: #{combined}" if combined.length > 1
    end
  end

  def get_beaconless_points(y)
    xs = {}
    @sensors.each do |s|
      pts = s.get_beaconless_row_points(y)
      #puts "#{s}: #{pts.length}"
      pts.each do |x|
        xs[x] = true
      end
    end

    xs.keys.length
  end
  def print(rows, cols)
    map = Array.new(cols) { Array.new(rows, '.') }

    @beacons.each {|b| map[b.x][b.y] = 'B'}
    @sensors.each do |s|
      map[s.x][s.y] = 'S'
      s.get_beaconless_area.each do |p|
        map[p.x][p.y] = '#' if map[p.x][p.y] == "." && p.x > 0 && p.y > 0
      end
    end

    (0..cols-1).each do |y|
      row = []
      (0..rows-1).each do |x|
        row.push(map[x][y])
      end
      puts "#{row.join('')}"
    end
  end
end
