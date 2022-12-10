require './cpu'

describe CPU do
  it 'tracks signal strengths' do
    cpu = CPU.new
    cpu.noop
    cpu.noop
    cpu.noop

    expect(cpu.get_signal_strength_at_cycle(1)).to eql(1)
    expect(cpu.get_signal_strength_at_cycle(2)).to eql(2)
    expect(cpu.get_signal_strength_at_cycle(3)).to eql(3)
  end

  it 'handles noop' do
    cpu = CPU.new
    cpu.noop
    expect(cpu.x).to eql(1)
    expect(cpu.cycle_counter).to eql(2)

    cpu.noop
    expect(cpu.x).to eql(1)
    expect(cpu.cycle_counter).to eql(3)
  end

  it 'handles addx' do
    cpu = CPU.new
    cpu.addx(20)
    expect(cpu.x).to eql(21)
    expect(cpu.cycle_counter).to eql(3)

    cpu.addx(-10)
    expect(cpu.x).to eql(11)
    expect(cpu.cycle_counter).to eql(5)
  end

  it 'processes command' do
    cpu = CPU.new
    cpu.process_command('noop')
    expect(cpu.x).to eql(1)
    expect(cpu.cycle_counter).to eql(2)

    cpu.process_command('addx 10')
    expect(cpu.x).to eql(11)
    expect(cpu.cycle_counter).to eql(4)
  end

  it 'processes test input' do
    cpu = CPU.new
    cpu.process_command_file('./testinput')

    signal20 = cpu.get_signal_strength_at_cycle(20)
    signal60 = cpu.get_signal_strength_at_cycle(60)
    signal100 = cpu.get_signal_strength_at_cycle(100)
    signal140 = cpu.get_signal_strength_at_cycle(140)
    signal180 = cpu.get_signal_strength_at_cycle(180)
    signal220 = cpu.get_signal_strength_at_cycle(220)

    expect(signal20).to eql(420)
    expect(signal60).to eql(1140)
    expect(signal100).to eql(1800)
    expect(signal140).to eql(2940)
    expect(signal180).to eql(2880)
    expect(signal220).to eql(3960)

  end
end
