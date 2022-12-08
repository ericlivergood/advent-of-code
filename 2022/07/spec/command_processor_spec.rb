require './command_processor'

test_input = [
  '$ cd /',
  '$ ls',
  'dir a',
  '14848514 b.txt',
  '8504156 c.dat',
  'dir d',
  '$ cd a',
  '$ ls',
  'dir e',
  '29116 f',
  '2557 g',
  '62596 h.lst',
  '$ cd e',
  '$ ls',
  '584 i',
  '$ cd ..',
  '$ cd ..',
  '$ cd d',
  '$ ls',
  '4060174 j',
  '8033020 d.log',
  '5626152 d.ext',
  '7214296 k'
]

describe CommandProcessor do
  it 'identifies a command' do
    p = CommandProcessor.new
    expect(p.is_command?('$ cd a')).to eql(true)
    expect(p.is_command?('$ ls')).to eql(true)
    expect(p.is_command?('dir e')).to eql(false)
    expect(p.is_command?('4060174 j')).to eql(false)
  end

  it 'navigates to subdirectory' do
    p = CommandProcessor.new
    p.process_line('$ cd a')

    expect(p.root.directories.length).to eql(1)
    expect(p.root.directories[0].name).to eql('a')
  end

  it 'navigates up' do
    p = CommandProcessor.new
    p.process_line('$ cd a')
    p.process_line('$ cd ..')
    p.process_line('$ cd b')

    expect(p.root.directories.length).to eql(2)
    expect(p.root.directories[0].name).to eql('a')
    expect(p.root.directories[1].name).to eql('b')
  end

  it 'goes to root' do
    p = CommandProcessor.new
    p.process_line('$ cd a')
    p.process_line('$ cd b')
    p.process_line('$ cd c')
    p.process_line('$ cd /')
    p.process_line('$ cd b')

    expect(p.root.directories.length).to eql(2)
    expect(p.root.directories[0].name).to eql('a')
    expect(p.root.directories[1].name).to eql('b')
  end

  it 'processes file data' do
    p = CommandProcessor.new
    p.process_line('14848514 b.txt')
    p.process_line('8033020 d.log')
    expect(p.root.files.length).to eql(2)
    expect(p.root.files[0].name).to eql('b.txt')
    expect(p.root.files[0].size).to eql(14848514)
    expect(p.root.files[1].name).to eql('d.log')
    expect(p.root.files[1].size).to eql(8033020)

    expect(p.root.get_tree_size).to eql(14848514+8033020)
    expect(p.root.size).to eql(14848514+8033020)
  end

  it 'processes file data in subdirs' do
    p = CommandProcessor.new
    p.process_line('$ cd a')
    p.process_line('14848514 b.txt')
    p.process_line('$ cd /')
    p.process_line('$ cd b')
    p.process_line('8033020 d.log')
    expect(p.root.files.length).to eql(0)
    expect(p.root.directories.length).to eql(2)
    expect(p.root.size).to eql(0)
    expect(p.root.get_tree_size).to eql(14848514+8033020)
  end

  it 'processes test input' do
    p = CommandProcessor.new

    test_input.each { |i| p.process_line(i) }
    expect(p.sum_of_subtrees_smaller_than(100000)).to eql(95437)
  end

  it 'finds directories to delete' do
    p = CommandProcessor.new

    test_input.each { |i| p.process_line(i) }
    dir = p.find_directory_to_delete(30000000)
    expect(dir.get_tree_size).to eql(24933642)
  end
end
