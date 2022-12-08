class DirFile
    attr_reader :name
    attr_reader :size

    def initialize(name, size)
        @name = name
        @size = size
    end
end

class Dir
    attr_reader :size
    attr_reader :files
    attr_reader :name
    attr_reader :directories
    def initialize(name)
        @name = name
        @files = []
        @directories = []
        @size = 0
    end

    def add_file(file)
        @files.push(file)
        @size += file.size
    end

    def add_directory(dir)
        @directories.push(dir)
    end

    def get_tree_size
        size = @size
        @directories.each do |d|
            size += d.get_tree_size
        end
        size
    end

    def find_subtrees_smaller_than(size)
        subtrees = []

        subtrees.push(self) if(get_tree_size <= size)
        #puts "#{@name} - #{get_tree_size} #{subtrees}"

        @directories.each do |d|
            d.find_subtrees_smaller_than(size).each { |x| subtrees.push(x) }
        end

        subtrees
    end

    def find_subtrees_bigger_than(size)
        subtrees = []

        subtrees.push(self) if(get_tree_size >= size)

        @directories.each do |d|
            d.find_subtrees_bigger_than(size).each { |x| subtrees.push(x) }
        end

        subtrees
    end
end
