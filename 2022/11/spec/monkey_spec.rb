require './monkey'

describe Monkey do
  it 'inspects an item' do
    monkey = Monkey.new([], ->(x) { 0 }, nil)
    expect(monkey.inspect_item(79)).to eql(0)
    monkey.inspect_item(79)
    monkey.inspect_item(79)
    expect(monkey.inpection_count).to eql(3)

    monkey = Monkey.new([], ->(x) { x * 19 }, nil)
    expect(monkey.inspect_item(79)).to eql(500)
 end

  it 'throws an item' do
    monkey2 = Monkey.new([], nil, nil)
    monkey = Monkey.new([], nil, ->(i) { monkey2 })

    monkey.throw_item(10)
    expect(monkey2.items.length).to eql(1)
    expect(monkey2.items[0]).to eql(10)
  end

  it 'handles items'  do
    monkey2 = Monkey.new([], nil, nil)
    monkey1 = Monkey.new([10, 20], ->(i) { i * 3 }, ->(i) { monkey2 })

    monkey1.handle_items

    expect(monkey1.items.length).to eql(0)
    expect(monkey2.items.length).to eql(2)
    expect(monkey2.items[0]).to eql(10)
    expect(monkey2.items[1]).to eql(20)
  end

  it 'runs test ' do
    monkeys = []
    monkey0 = Monkey.new([79, 98], ->(x) { x * 19}, ->(x) { x % 23 == 0 ? monkeys[2] : monkeys[3]})
    monkey1 = Monkey.new([54, 65, 75, 74], ->(x) { x + 6}, ->(x) { x % 19 == 0 ? monkeys[2] : monkeys[0] })
    monkey2 = Monkey.new([79, 60, 97], ->(x) { x * x}, ->(x) { x % 13 == 0 ? monkeys[1] : monkeys[3] })
    monkey3 = Monkey.new([74], ->(x) { x + 3 }, ->(x) { x % 17 == 0 ? monkeys[0] : monkeys[1] })
    
    monkeys = [
      monkey0, monkey1, monkey2, monkey3
    ]

    (1..20).each do |i|
      monkeys.each do |m|
        m.handle_items
      end
      # puts "ROUND #{i}"
      # (0..monkeys.length-1).each do |j|
      #   puts "Monkey #{j}: #{monkeys[j].items}"
      # end
      # puts ""
    end
    counts = []
    monkeys.each { |m| counts.push(m.inpection_count) }
    counts = counts.sort.reverse
    expect(counts[0] * counts[1]).to eql(10605)
  end  

  it 'runs test - part 2' do
    monkeys = []
    monkey0 = Monkey.new([79, 98], ->(x) { x * 19}, ->(x) { x % 23 == 0 ? monkeys[2] : monkeys[3]}, false)
    monkey1 = Monkey.new([54, 65, 75, 74], ->(x) { x + 6}, ->(x) { x % 19 == 0 ? monkeys[2] : monkeys[0] }, false)
    monkey2 = Monkey.new([79, 60, 97], ->(x) { x * x}, ->(x) { x % 13 == 0 ? monkeys[1] : monkeys[3] }, false)
    monkey3 = Monkey.new([74], ->(x) { x + 3 }, ->(x) { x % 17 == 0 ? monkeys[0] : monkeys[1] }, false)
    
    monkeys = [
      monkey0, monkey1, monkey2, monkey3
    ]

    (1..10000).each do |i|
      #puts i
      monkeys.each do |m|
        m.handle_items
      end

      # if([1, 20, 1000, 2000].include?(i))
      #   #puts "ROUND #{i}"
      #   (0..monkeys.length-1).each do |j|
      #     #puts "Monkey #{j}: #{monkeys[j].items}"
      #     puts "Monkey #{j}: #{monkeys[j].inpection_count}"
      #   end
      #   puts ""
      # end
    end
    counts = []
    monkeys.each { |m| counts.push(m.inpection_count) }
    counts = counts.sort.reverse
    expect(counts[0]).to eql(52166)
    expect(counts[1]).to eql(52013)
    expect(counts[0] * counts[1]).to eql(2713310158)
  end  
end