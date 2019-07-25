using TuringMachine

input_file = "example_input_1.txt"
program_file = "example_program_1.txt"

input = load_input(input_file)
program, init_state, halt_state = load_program(program_file)

state, tape_left, tape_right = set_up(init_state, input)

# run simulation step-by-step until we reach a halting state of 'accept' or 'reject'
while true
    try
        global state, tape_left, tape_right = simulate(state, program, tape_left, tape_right)
        println(state)
        state ==("qAccept") && break
        state ==("qReject") && break
    catch err
        println(err) && break
    end
end
