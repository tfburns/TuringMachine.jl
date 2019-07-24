include("simulator.jl")

input_file = "example_input_1.txt"
program_file = "example_program_1.txt"

input = load_input(input_file)
program, init_state, halt_state = load_program(program_file)

tape_left, tape_right = set_up(input)
