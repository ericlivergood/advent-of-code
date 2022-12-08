require './dir'

describe Dir do
    it 'adds subdirectory' do
        root = Dir.new('/')
        root.add_directory(Dir.new('sub'))

        expect(root.directories.length).to eql(1)
        expect(root.directories[0].name).to eql('sub')
    end
    it 'adds file' do
        root = Dir.new('/')
        root.add_file(DirFile.new('file', 100))

        expect(root.files.length).to eql(1)
        expect(root.files[0].name).to eql('file')
    end
    it 'maintains current size' do
        root = Dir.new('/')
        root.add_file(DirFile.new('test', 100))
        root.add_file(DirFile.new('test2', 200))

        expect(root.size).to eql(300)
    end
    it 'calculates subtree size - no children' do
        root = Dir.new('/')
        root.add_file(DirFile.new('test', 100))
        root.add_file(DirFile.new('test2', 200))

        expect(root.get_tree_size).to eql(300)
    end

    it 'calculates subtree size - one level' do
        root = Dir.new('/')
        root.add_file(DirFile.new('test', 100))
        root.add_file(DirFile.new('test2', 200))
        sub_dir_1 = Dir.new('a')
        sub_dir_1.add_file(DirFile.new('test a', 300))
        sub_dir_2 = Dir.new('b')
        sub_dir_2.add_file(DirFile.new('test b', 400))
        root.add_directory(sub_dir_1)
        root.add_directory(sub_dir_2)

        expect(root.get_tree_size).to eql(1000)
    end

    it 'calculates subtree size - multi level' do
        root = Dir.new('/')
        root.add_file(DirFile.new('test', 100))
        root.add_file(DirFile.new('test2', 200))
        sub_dir_1 = Dir.new('a')
        sub_dir_1.add_file(DirFile.new('test a', 300))
        sub_dir_2 = Dir.new('b')
        sub_dir_2.add_file(DirFile.new('test b', 400))
        root.add_directory(sub_dir_1)
        sub_dir_1.add_directory(sub_dir_2)

        expect(root.get_tree_size).to eql(1000)
    end
end
