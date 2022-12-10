class CPU
  attr_reader :x
  attr_reader :cycle_counter

  def initialize
    @cycle_counter = 1
    @x_history = [0]
    @x = 1
  end

  def noop
    advance
  end

  def addx(n)
    advance
    advance
    @x += n
  end

  def advance
    @x_history.push(@x)
    @cycle_counter += 1
  end

  def compute_signal_strength
    #puts "#{@cycle_counter}: #{x}"
    @x * @cycle_counter
  end

  def is_lit_at?(x, cycle)
    sprite = @x_history[cycle]
    #puts "cycle: #{cycle} | x: #{x} | sprite: #{sprite-1}-#{sprite+1}"
    (sprite >= (x - 1)) && (sprite <= (x + 1))
  end

  def get_signal_strength_at_cycle(n)
    return nil if n > @x_history.length

    @x_history[n] * n
  end

  def process_command(str)
    if str.strip == "noop"
      noop
    elsif str.strip.start_with? "addx"
      n = str.split(' ')[1].strip.to_i
      addx(n)
    end
  end

  def process_command_file(filename)
    lines = []
    File.foreach(filename) do |line|
      process_command(line)
    end
  end
end


class CRT
  def initialize(cpu)
    @cpu = cpu
  end

  def draw
    rows = []
    (0..5).each do |y|
      row = []
      rows.push(row)
      (0..39).each do |x|
        cycle = 40*y + x + 1
        if(@cpu.is_lit_at?(x, cycle))
          row.push('#')
        else
          row.push('.')
        end
      end
    end

    rows.each{ |r| puts r.join('')}
  end
end
