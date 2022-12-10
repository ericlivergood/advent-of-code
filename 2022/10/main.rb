require './cpu'

cpu = CPU.new
cpu.process_command_file('./commands')
#cpu.process_command_file('./testinput')

crt = CRT.new(cpu)
crt.draw
