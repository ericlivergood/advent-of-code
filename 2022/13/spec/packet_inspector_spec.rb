require './packet_inspector'

test_input = [
  '[1,1,3,1,1]',
  '[1,1,5,1,1]',
  '',
  '[[1],[2,3,4]]',
  '[[1],4]',
  '',
  '[9]',
  '[[8,7,6]]',
  '',
  '[[4,4],4,4]',
  '[[4,4],4,4,4]',
  '',
  '[7,7,7,7]',
  '[7,7,7]',
  '',
  '[]',
  '[3]',
  '',
  '[[[]]]',
  '[[]]',
  '',
  '[1,[2,[3,[4,[5,6,7]]]],8,9]',
  '[1,[2,[3,[4,[5,6,0]]]],8,9]'
]



describe PacketInspector do
  it 'computes correct order' do
    i = PacketInspector.new
    expect(i.is_in_right_order?([1,1,3,1,1],[1,1,5,1,1])).to eql(true)
    expect(i.is_in_right_order?([[1],[2,3,4]],[[1],4])).to eql(true)
    expect(i.is_in_right_order?([9],[[8,7,6]])).to eql(false)
    expect(i.is_in_right_order?([[4,4],4,4],[[4,4],4,4,4])).to eql(true)
    expect(i.is_in_right_order?([7,7,7,7],[7,7,7])).to eql(false)
    expect(i.is_in_right_order?([],[3])).to eql(true)
    expect(i.is_in_right_order?([[[]]],[[]])).to eql(false)
    expect(i.is_in_right_order?([1,[2,[3,[4,[5,6,7]]]],8,9],[1,[2,[3,[4,[5,6,0]]]],8,9])).to eql(false)
  end

  it 'computes_index_sum' do
    input = test_input.map {|t| eval(t)}
    i = PacketInspector.new
    expect(i.compute_index_sum(input)).to eql(13)
  end

  it 'detects decoder packet' do
    i = PacketInspector.new
    expect(i.is_decoder_packet?([[2]])).to eql(true)
    expect(i.is_decoder_packet?([[6]])).to eql(true)

    expect(i.is_decoder_packet?([[2],1])).to eql(false)
    expect(i.is_decoder_packet?([[1,6]])).to eql(false)

    expect(i.is_decoder_packet?([2])).to eql(false)
    expect(i.is_decoder_packet?([6])).to eql(false)

    expect(i.is_decoder_packet?(eval('[[2]]'))).to eql(true)
    expect(i.is_decoder_packet?(eval('[[6]]'))).to eql(true)
  end

  it 'sorts packets' do
    input = [
      [5],[4],[3],[2]
    ]

    i = PacketInspector.new
    sorted = i.sort_packets(input)
    expect(sorted.length).to eql(4)
    expect(sorted[0]).to eql([2])
    expect(sorted[1]).to eql([3])
    expect(sorted[2]).to eql([4])
    expect(sorted[3]).to eql([5])
  end

  it 'calculates test decoder key' do
    input = test_input.map {|t| eval(t)}
    i = PacketInspector.new
    expect(i.get_decoder_key(input)).to eql(140)
  end
end
