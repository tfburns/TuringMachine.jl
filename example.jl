include("simulator.jl")

input_file = "example_input_1.txt"
program_file = "example_program_1.txt"

input = load_input(input_file)
program, init_state, halt_state = load_program(program_file)

state, tape_left, tape_right = set_up(init_state, input)

# run simulation step-by-step until we reach the halting state
while true
    try
        global state, tape_left, tape_right = simulate(state, program, tape_left, tape_right)
        println(state)
        state ==("qAccept") && break
    catch err
        global state = "qReject"
        println(state)
        state ==("qReject") && break
    end
end
