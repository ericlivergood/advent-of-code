require './tree_map'

test_input = [
  '30373',
  '25512',
  '65332',
  '33549',
  '35390'
]

test_input_2 = [
  '00000',
  '06660',
  '06560',
  '06660',
  '00000',
]

describe TreeMap do
  it 'parses map' do
    m = TreeMap.new(test_input)
    expect(m.map[0][0]).to eql(3)
    expect(m.map[0][1]).to eql(0)
    expect(m.map[0][4]).to eql(3)
    expect(m.map[1][0]).to eql(2)
    expect(m.map[1][4]).to eql(2)
    expect(m.map[4][0]).to eql(3)
    expect(m.map[4][4]).to eql(0)
  end

  it 'detects taller than all' do
    m = TreeMap.new([])
    expect(m.is_taller_than_all?(1, [])).to eql(true)
    expect(m.is_taller_than_all?(5, [1])).to eql(true)
    expect(m.is_taller_than_all?(5, [1,2,3,4])).to eql(true)
    expect(m.is_taller_than_all?(4, [1,2,3,4])).to eql(false)
    expect(m.is_taller_than_all?(1, [1,2,3,4])).to eql(false)
  end

  it 'detects visibilty from top' do
    m = TreeMap.new(test_input)
    expect(m.is_visible_from_top?(0,0)).to eql(true)
    expect(m.is_visible_from_top?(0,1)).to eql(false)
    expect(m.is_visible_from_top?(0,2)).to eql(true)
    expect(m.is_visible_from_top?(0,3)).to eql(false)
    expect(m.is_visible_from_top?(0,4)).to eql(false)

    expect(m.is_visible_from_top?(1,0)).to eql(true)
    expect(m.is_visible_from_top?(1,1)).to eql(true)
    expect(m.is_visible_from_top?(1,2)).to eql(false)
    expect(m.is_visible_from_top?(1,3)).to eql(false)
    expect(m.is_visible_from_top?(1,4)).to eql(false)

    expect(m.is_visible_from_top?(2,0)).to eql(true)
    expect(m.is_visible_from_top?(2,1)).to eql(true)
    expect(m.is_visible_from_top?(2,2)).to eql(false)
    expect(m.is_visible_from_top?(2,3)).to eql(false)
    expect(m.is_visible_from_top?(2,4)).to eql(false)

    expect(m.is_visible_from_top?(3,0)).to eql(true)
    expect(m.is_visible_from_top?(3,1)).to eql(false)
    expect(m.is_visible_from_top?(3,2)).to eql(false)
    expect(m.is_visible_from_top?(3,3)).to eql(false)
    expect(m.is_visible_from_top?(3,4)).to eql(true)

    expect(m.is_visible_from_top?(4,0)).to eql(true)
    expect(m.is_visible_from_top?(4,1)).to eql(false)
    expect(m.is_visible_from_top?(4,2)).to eql(false)
    expect(m.is_visible_from_top?(4,3)).to eql(true)
    expect(m.is_visible_from_top?(4,4)).to eql(false)
  end

  it 'detects visibilty from bottom' do
    m = TreeMap.new(test_input)
    expect(m.is_visible_from_bottom?(0,0)).to eql(false)
    expect(m.is_visible_from_bottom?(0,1)).to eql(false)
    expect(m.is_visible_from_bottom?(0,2)).to eql(true)
    expect(m.is_visible_from_bottom?(0,3)).to eql(false)
    expect(m.is_visible_from_bottom?(0,4)).to eql(true)

    expect(m.is_visible_from_bottom?(1,0)).to eql(false)
    expect(m.is_visible_from_bottom?(1,1)).to eql(false)
    expect(m.is_visible_from_bottom?(1,2)).to eql(false)
    expect(m.is_visible_from_bottom?(1,3)).to eql(false)
    expect(m.is_visible_from_bottom?(1,4)).to eql(true)

    expect(m.is_visible_from_bottom?(2,0)).to eql(false)
    expect(m.is_visible_from_bottom?(2,1)).to eql(false)
    expect(m.is_visible_from_bottom?(2,2)).to eql(false)
    expect(m.is_visible_from_bottom?(2,3)).to eql(true)
    expect(m.is_visible_from_bottom?(2,4)).to eql(true)

    expect(m.is_visible_from_bottom?(3,0)).to eql(false)
    expect(m.is_visible_from_bottom?(3,1)).to eql(false)
    expect(m.is_visible_from_bottom?(3,2)).to eql(false)
    expect(m.is_visible_from_bottom?(3,3)).to eql(false)
    expect(m.is_visible_from_bottom?(3,4)).to eql(true)

    expect(m.is_visible_from_bottom?(4,0)).to eql(false)
    expect(m.is_visible_from_bottom?(4,1)).to eql(false)
    expect(m.is_visible_from_bottom?(4,2)).to eql(false)
    expect(m.is_visible_from_bottom?(4,3)).to eql(true)
    expect(m.is_visible_from_bottom?(4,4)).to eql(true)
  end

  it 'detects visibilty from left' do
    m = TreeMap.new(test_input)
    expect(m.is_visible_from_left?(0,0)).to eql(true)
    expect(m.is_visible_from_left?(1,0)).to eql(false)
    expect(m.is_visible_from_left?(2,0)).to eql(false)
    expect(m.is_visible_from_left?(3,0)).to eql(true)
    expect(m.is_visible_from_left?(4,0)).to eql(false)

    expect(m.is_visible_from_left?(0,1)).to eql(true)
    expect(m.is_visible_from_left?(1,1)).to eql(true)
    expect(m.is_visible_from_left?(2,1)).to eql(false)
    expect(m.is_visible_from_left?(3,1)).to eql(false)
    expect(m.is_visible_from_left?(4,1)).to eql(false)

    expect(m.is_visible_from_left?(0,2)).to eql(true)
    expect(m.is_visible_from_left?(1,2)).to eql(false)
    expect(m.is_visible_from_left?(2,2)).to eql(false)
    expect(m.is_visible_from_left?(3,2)).to eql(false)
    expect(m.is_visible_from_left?(4,2)).to eql(false)

    expect(m.is_visible_from_left?(0,3)).to eql(true)
    expect(m.is_visible_from_left?(1,3)).to eql(false)
    expect(m.is_visible_from_left?(2,3)).to eql(true)
    expect(m.is_visible_from_left?(3,3)).to eql(false)
    expect(m.is_visible_from_left?(4,3)).to eql(true)

    expect(m.is_visible_from_left?(0,4)).to eql(true)
    expect(m.is_visible_from_left?(1,4)).to eql(true)
    expect(m.is_visible_from_left?(2,4)).to eql(false)
    expect(m.is_visible_from_left?(3,4)).to eql(true)
    expect(m.is_visible_from_left?(4,4)).to eql(false)
  end


  it 'detects visibilty from right' do
    m = TreeMap.new(test_input)
    expect(m.is_visible_from_right?(0,0)).to eql(false)
    expect(m.is_visible_from_right?(1,0)).to eql(false)
    expect(m.is_visible_from_right?(2,0)).to eql(false)
    expect(m.is_visible_from_right?(3,0)).to eql(true)
    expect(m.is_visible_from_right?(4,0)).to eql(true)

    expect(m.is_visible_from_right?(0,1)).to eql(false)
    expect(m.is_visible_from_right?(1,1)).to eql(false)
    expect(m.is_visible_from_right?(2,1)).to eql(true)
    expect(m.is_visible_from_right?(3,1)).to eql(false)
    expect(m.is_visible_from_right?(4,1)).to eql(true)

    expect(m.is_visible_from_right?(0,2)).to eql(true)
    expect(m.is_visible_from_right?(1,2)).to eql(true)
    expect(m.is_visible_from_right?(2,2)).to eql(false)
    expect(m.is_visible_from_right?(3,2)).to eql(true)
    expect(m.is_visible_from_right?(4,2)).to eql(true)

    expect(m.is_visible_from_right?(0,3)).to eql(false)
    expect(m.is_visible_from_right?(1,3)).to eql(false)
    expect(m.is_visible_from_right?(2,3)).to eql(false)
    expect(m.is_visible_from_right?(3,3)).to eql(false)
    expect(m.is_visible_from_right?(4,3)).to eql(true)

    expect(m.is_visible_from_right?(0,4)).to eql(false)
    expect(m.is_visible_from_right?(1,4)).to eql(false)
    expect(m.is_visible_from_right?(2,4)).to eql(false)
    expect(m.is_visible_from_right?(3,4)).to eql(true)
    expect(m.is_visible_from_right?(4,4)).to eql(true)
  end

  it 'counts visible' do
    m = TreeMap.new(test_input)
    expect(m.get_visible_count).to eql(21)
  end

  it 'counts visible test 2' do
    m = TreeMap.new(test_input_2)
    expect(m.get_visible_count).to eql(24)
  end

  it 'calculates scenic score' do
    m = TreeMap.new(test_input)

    expect(m.calculate_scenic_score(2,1)).to eql(4)
    expect(m.calculate_scenic_score(2,3)).to eql(8)
  end
end


# test_input = [
#   '30373',
#   '25512',
#   '65332',
#   '33549',
#   '35390'
# ]
