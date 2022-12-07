require './main'

start = [
  '    [D]     ',
  '[N] [C]     ',
  '[Z] [M] [P] ',
  ' 1   2   3  '
]

commands = [
  'move 1 from 2 to 1',
  'move 3 from 1 to 3',
  'move 2 from 2 to 1',
  'move 1 from 1 to 2'
]

describe CrateStacks do
  it 'shreds a header row' do
    shredded = CrateStacks.shred_row(' 1   2   3  ')
    expect(shredded.length).to eql(3)
    expect(shredded[0]).to eql('1')
    expect(shredded[1]).to eql('2')
    expect(shredded[2]).to eql('3')
  end

  it 'shreds a data row' do
    shredded = CrateStacks.shred_row('[Z]     [P] ')
    expect(shredded.length).to eql(3)
    expect(shredded[0]).to eql('[Z]')
    expect(shredded[1]).to eql(nil)
    expect(shredded[2]).to eql('[P]')
  end

  it 'parses starting headers' do
    s = [' 1   2   3   4   5   6   7   8   9  ']
    parsed = CrateStacks.parse_starting_positions(s)
    expect(parsed.length).to eql(9)
  end

  it 'parses starting positions' do
    parsed = CrateStacks.parse_starting_positions(start)
    expect(parsed.length).to eql(3)
    expect(parsed[0][0]).to eql('[Z]')
    expect(parsed[0][1]).to eql('[N]')
    expect(parsed[0][2]).to eql(nil)
    expect(parsed[1][0]).to eql('[M]')
    expect(parsed[1][1]).to eql('[C]')
    expect(parsed[1][2]).to eql('[D]')
    expect(parsed[2][0]).to eql('[P]')
    expect(parsed[2][1]).to eql(nil)
    expect(parsed[2][2]).to eql(nil)
  end

  it 'parses move command' do
    parsed = CrateStacks.parse_command('move 1 from 1 to 2')
    expect(parsed[0]).to eql(1)
    expect(parsed[1]).to eql(1)
    expect(parsed[2]).to eql(2)

    parsed = CrateStacks.parse_command('move 10 from 5 to 7')
    expect(parsed[0]).to eql(10)
    expect(parsed[1]).to eql(5)
    expect(parsed[2]).to eql(7)
  end

  it 'processes test answer' do
    stack = CrateStacks.new(start)
    stack.print
    commands.each do |c| 
      stack.process_move_command(c) 
      stack.print
    end
    puts stack.to_tops_s
    expect(stack.to_tops_s).to eql('MCD')
  end
end
