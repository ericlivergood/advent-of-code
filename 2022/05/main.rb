class CrateStacks
  def self.parse_starting_positions(starting_positions)
    reversed = starting_positions.reverse
    stack_count = shred_row(reversed[0]).length
    stacks = Array.new(stack_count)

    reversed[1..reversed.length - 1].each do |row|
      cols = shred_row(row)
      for i in 0..stack_count-1
        stacks[i] = [] if stacks[i].nil?
        stacks[i].push(cols[i]) unless cols[i].nil?
      end
    end
    stacks
  end

  def initialize(starting_positions)
    @current = CrateStacks.parse_starting_positions(starting_positions)
  end

  def self.shred_row(row)
    cols = []
    n = 0

    while n < row.length
      value = row[n..n + 3].strip
      cols.push(value) if value != ''
      cols.push(nil) if value == ''
      n += 4
    end

    cols
  end

  def self.parse_command(s)
    matcher = /move (?<count>([0-9]+)) from (?<from>([0-9+]+)) to (?<to>([0-9]+))/
    values = matcher.match(s).named_captures
    [
      values['count']&.strip.to_i,
      values['from']&.strip.to_i,
      values['to']&.strip.to_i
    ]
  end

  def process_move_command(s) 
    count, from, to = CrateStacks.parse_command(s)
    process_move(count, from, to)
  end

  def process_move(count, from, to)
    to_move = @current[from - 1].pop(count)
    to_move.each{ |m| @current[to - 1].push(m) }
  end

  def print
    i = 0
    puts "CURRENT:"
    @current.each do |r| 
      i += 1
      puts "#{i}: #{r}" 
    end      
    puts "---------"
    puts ""
  end

  def to_tops_s
    answer = ''
    @current.each{ |r| answer += r[r.length-1].to_s.sub('[', '').sub(']', '').strip }
    answer
  end

  def self.run
    commands = []
    start = []
    File.foreach("./commands") { |line| commands.push(line) }
    File.foreach("./start") { |line| start.push(line) }

    stacks = CrateStacks.new(start)
    commands.each{ |c| stacks.process_move_command(c) }
    puts stacks.to_tops_s
  end
end

CrateStacks.run