using Test, TuringMachine, DataStructures

# test load_input
input_file = "test_input_1.txt"
input_1 = collect("111000011")
input = load_input(input_file)
@test typeof(load_input(input_file)) == Array{Char,1}
@test input == input_1

# test load_program
program_file = "test_program_1.txt"
program, init_state, halt_state = load_program(program_file)
@test typeof(program) == Dict{Any,Any}
@test init_state == "q0"
@test halt_state == "qAccept"
@test in(("q2", "_") => ("qReject", "_", "-"), program)
@test in(("q0", "_") => ("qAccept", "_", "-"), program)
@test in(("q2", "1") => ("q2", "1", ">"), program)

# test set_up
state, tape_left, tape_right = set_up(init_state, input)
@test state == "q0"
@test isempty(tape_left)
@test length(tape_right) == length(input_1)
@test front(tape_right) == parse(Int, input_1[1])
@test back(tape_right) == parse(Int, input_1[end])

# test simulate
state, tape_left, tape_right = simulate(state, program, tape_left, tape_right)
@test state == "q1"
@test length(tape_left) == 1
@test front(tape_left) == parse(Int, input_1[1])
@test length(tape_right) == length(input_1)-1
@test front(tape_right) == parse(Int, input_1[2])
@test back(tape_right) == parse(Int, input_1[end])
while true
        global state, tape_left, tape_right = simulate(state, program, tape_left, tape_right)
        state ==("qAccept") && break
        state ==("qReject") && break
end
@test state == "qReject"
@test isempty(tape_right)
@test length(tape_left) == length(input_1)
@test front(tape_left) == parse(Int, input_1[1])
@test back(tape_left) == parse(Int, input_1[end])
