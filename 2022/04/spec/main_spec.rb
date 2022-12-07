require './main'

test_data = [
  '2-4,6-8',
  '2-3,4-5',
  '5-7,7-9',
  '2-8,3-7',
  '6-6,4-6',
  '2-6,4-8'
]

describe Day4 do
  it 'expands assignments 2-4' do
    expansions = Day4.expand_assignments('2-4,5-8')
    expect(expansions.length).to eql(2)

    expect(expansions[0].length).to eql(3)
    expect(expansions[0][0]).to eql(2)
    expect(expansions[0][1]).to eql(3)
    expect(expansions[0][2]).to eql(4)

    expect(expansions[1].length).to eql(4)
    expect(expansions[1][0]).to eql(5)
    expect(expansions[1][1]).to eql(6)
    expect(expansions[1][2]).to eql(7)
    expect(expansions[1][3]).to eql(8)
  end

  it 'finds_overlapping_assignments' do
    assignments = [
      [2, 3, 4],
      [3, 4, 5]
    ]

    overlap = Day4.find_overlapping_assignments(assignments)
    expect(overlap.length).to eql(2)
    expect(overlap[0]).to eql(3)
    expect(overlap[1]).to eql(4)
  end

  it 'finds_no_overlap' do
    assignments = [
      [2, 3, 4],
      [5, 6, 7]
    ]

    overlap = Day4.find_overlapping_assignments(assignments)
    expect(overlap.length).to eql(0)
  end

  it 'finds encapsulated assignments' do
    expect(Day4.contains_encapsulated_assignment?([[1, 2, 3], [2, 3]])).to eql(true)
    expect(Day4.contains_encapsulated_assignment?([[1, 2], [2, 3]])).to eql(false)
  end

  it 'calculates encapsulated count from test_data' do
    expect(Day4.count_encapsulated_assignments(test_data)).to eql(2)
  end

  it 'it returns has_overlap' do
    expect(Day4.overlap?([[1, 2], [2, 3]])).to eql(true)
    expect(Day4.overlap?([[1, 2], [3, 4]])).to eql(false)
  end

  it 'calculates overlapping count from test_data' do
    expect(Day4.count_overlapping_assignments(test_data)).to eql(4)
  end
end
