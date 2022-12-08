require './dir'

class CommandProcessor
    attr_reader :root

    def initialize()
        @tree = []
        @current = Dir.new("/")
        @root = @current
    end

    def is_command?(s)
        s.start_with?('$')
    end

    def go_to(dir)
        dir = dir.strip
        if dir == "/"
            @tree = []
            @current = @root
            return
        elsif dir == ".."
            @current = @tree.pop
            return
        else
            child = Dir.new(dir)
            @current.add_directory(child)
            @tree.push(@current)
            @current = child
        end
    end

    def do_command(cmd)
        cmd = cmd.sub('$', '').strip
        if(cmd.start_with?('cd'))
            go_to(cmd.sub('cd', '').strip)
        end
    end

    def process_data(data)
        parts = data.split(' ')
        file = DirFile.new(parts[1].strip, parts[0].strip.to_i)
        @current.add_file(file)
    end

    def process_line(line)
        if is_command?(line)
            do_command(line)
        else
            process_data(line)
        end
    end

    def find_subtrees_smaller_than(size)
        root.find_subtrees_smaller_than(size)
    end

    def sum_of_subtrees_smaller_than(size)
        sum = find_subtrees_smaller_than(size).reduce(0) {
            |sum, dir|
            sum+dir.get_tree_size
        }
        sum
    end

    def find_directory_to_delete(space_needed)
        current_space = 70000000 - root.get_tree_size
        dirs = root.find_subtrees_bigger_than(space_needed-current_space)
        dirs = dirs.sort_by(&:get_tree_size)
        #dirs.each{ |x| puts x.get_tree_size }
        dirs[0]
    end
end
