require './rope_bridge'

describe RopeBridge do
  it 'moves head' do
    start_x = 5
    start_y = 5-1
    b = RopeBridge.new(10,10,2)
    expect(b.head.x).to eql(0 + start_x)
    expect(b.head.y).to eql(9 - start_y)

    b.move_head(:up, 2)
    expect(b.head.x).to eql(0 + start_x)
    expect(b.head.y).to eql(7 - start_y)

    b.move_head(:right, 3)
    expect(b.head.x).to eql(3 + start_x)
    expect(b.head.y).to eql(7 - start_y)

    b.move_head(:down, 1)
    expect(b.head.x).to eql(3 + start_x)
    expect(b.head.y).to eql(8 - start_y)

    b.move_head(:left, 2)
    expect(b.head.x).to eql(1 + start_x)
    expect(b.head.y).to eql(8 - start_y)
  end

  it 'moves tail with head' do
    start_x = 5
    start_y = 5 - 1
    b = RopeBridge.new(10,10,2)
    b.move_head(:up, 2)
    expect(b.tail.x).to eql(0 + start_x)
    expect(b.tail.y).to eql(8 - start_y)

    b.move_head(:right, 3)
    expect(b.tail.x).to eql(2 + start_x)
    expect(b.tail.y).to eql(7 - start_y)

    b.move_head(:down, 1)
    expect(b.tail.x).to eql(2 + start_x)
    expect(b.tail.y).to eql(7 - start_y)

    b.move_head(:left, 2)
    expect(b.tail.x).to eql(2 + start_x)
    expect(b.tail.y).to eql(7 - start_y)
  end

  it 'detects adjacency' do
    x = KnotPosition.new(5,5)
    expect(x.is_adjacent_to?(KnotPosition.new(5,5))).to eql(true)
    expect(x.is_adjacent_to?(KnotPosition.new(6,6))).to eql(true)
    expect(x.is_adjacent_to?(KnotPosition.new(5,7))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(6,7))).to eql(false)

    expect(x.is_adjacent_to?(KnotPosition.new(4,4))).to eql(true)
    expect(x.is_adjacent_to?(KnotPosition.new(5,3))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(4,3))).to eql(false)

    expect(x.is_adjacent_to?(KnotPosition.new(7,5))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(7,6))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(7,7))).to eql(false)

    expect(x.is_adjacent_to?(KnotPosition.new(3,5))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(5,3))).to eql(false)
    expect(x.is_adjacent_to?(KnotPosition.new(3,3))).to eql(false)
  end

  it 'moves to adjacent position' do
    head = KnotPosition.new(1,5)

    tail = KnotPosition.new(0,3)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(1)
    expect(tail.y).to eql(4)

    tail = KnotPosition.new(0,4)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(0)
    expect(tail.y).to eql(4)

    tail = KnotPosition.new(1,3)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(1)
    expect(tail.y).to eql(4)

    tail = KnotPosition.new(1,4)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(1)
    expect(tail.y).to eql(4)

    tail = KnotPosition.new(2,7)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(1)
    expect(tail.y).to eql(6)

    tail = KnotPosition.new(1,7)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(1)
    expect(tail.y).to eql(6)

    tail = KnotPosition.new(2,6)
    tail.move_adjacent_to(head)
    expect(tail.x).to eql(2)
    expect(tail.y).to eql(6)
  end

  it 'follows test directions' do
    directions = [
      'R 4',
      'U 4',
      'L 3',
      'D 1',
      'R 4',
      'D 1',
      'L 5',
      'R 2'
    ]
    b = RopeBridge.new(100,100,2)
    directions.each do |d|
      b.move(d)
    end
    expect(b.tail_visited_count).to eql(13)
  end

  it 'follows test directions - part 2' do
    directions = [
      'R 4',
      'U 4',
      'L 3',
      'D 1',
      'R 4',
      'D 1',
      'L 5',
      'R 2'
    ]
    b = RopeBridge.new(100,100,10)
    directions.each do |d|
      b.move(d)
    end
    expect(b.tail_visited_count).to eql(1)
  end
  it 'follows test directions - part 2.2' do
    directions = [
      'R 5',
      'U 8',
      'L 8',
      'D 3',
      'R 17',
      'D 10',
      'L 25',
      'U 20'
    ]
    b = RopeBridge.new(100,100,10)
    directions.each do |d|
      b.move(d)
    end
    expect(b.tail_visited_count).to eql(36)
  end

  it 'computes is_at' do
    expect(KnotPosition.new(1,1).is_at(1,1)).to eql(true)
    expect(KnotPosition.new(2,2).is_at(1,1)).to eql(false)
    expect(KnotPosition.new(2,1).is_at(1,1)).to eql(false)
    expect(KnotPosition.new(21,11).is_at(21,11)).to eql(true)
  end

  # it 'prints' do
  #   directions = [
  #     'R 5',
  #     'U 8',
  #     'L 8',
  #     'D 3',
  #     'R 17',
  #     'D 10',
  #     'L 25',
  #     'U 20'
  #   ]
  #   b = RopeBridge.new(100,100,10)
  #   directions.each do |d|
  #     b.move(d)
  #   end
  #   b.print
  # end
end
