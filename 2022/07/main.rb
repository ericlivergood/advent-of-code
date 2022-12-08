require './command_processor'

p = CommandProcessor.new
File.foreach("./commands") { |line| p.process_line(line) }

#puts p.sum_of_subtrees_smaller_than(100000)
dir = p.find_directory_to_delete(30000000)
puts dir.get_tree_size
