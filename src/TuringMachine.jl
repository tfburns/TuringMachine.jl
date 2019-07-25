module TuringMachine
export load_input, load_program, set_up, simulate

using DataStructures, DelimitedFiles

"""
    load_input(file_name)

Takes a text file containing a continuous string of `n` integers (no spaces) and returns an `n`-element
array, where each element is an integer. The array is ordered as the input string.

Input
- `file_name`::string : path of text file containing an input string of `n` integers (no spaces)

Output
- ::`n`-element Array{Char, 1} : output array of integers, ordered as the input string
"""
function load_input(file_name)
    file = readdlm(file_name, String)
    return collect(file[])
end

"""
    load_program(file_name)

Takes a text file containing a Turing program. Please see docs for how to write such a program.

Input
- `file_name`::string : path of text file containing the Turing program to simulate

Output
- `program`::Dict{Any,Any} with `m` entries: dictionary with keys of [states,read_cells] and values of [next_state,write_cell,movement]
"""
function load_program(file_name)
    program_raw = readdlm(file_name)
    rows, cols = size(program_raw)
    program = Dict{Any,Any}()
    init_state = []
    halt_state = []
    for i = 1:rows
        if program_raw[i,1] == "//"
            continue
        else
            if program_raw[i,1] == "init:"
                push!(init_state, program_raw[i,2])
            elseif program_raw[i,1] == "halt:"
                push!(halt_state, program_raw[i,2])
            else
                card = split(program_raw[i,1], r",")
                state_read = (String(card[1]),String(card[2]))
                instruction = (String(card[3]),String(card[4]),String(card[5]))
                program[state_read] = instruction
            end
        end
    end
    return program, init_state[], halt_state[]
end

"""
    set_up(init_state, input)

Performs initial set-up for the simulation of single tape. The `length(input)` must be equal of greater
than 1. The input will be placed on tape to the right of the head.

Input
- `input`::`n`-element Array{Char, 1} : initial data to insert to the right of the head
- `init_state`::String : string label for initial/starting state of the Turing machine

Outputs
- `tape_left`::Deque{Int} : initial values for the stack to the left of the head
- `tape_right`::Deque{Int} : initial values for the stack to the right of the head
"""
function set_up(init_state, input)
    # set up two stacks to simulate a single tape
    tape_left = Deque{Int}() # simulates tape lying to the left of the head
    tape_right = Deque{Int}() # simulates tape lying to the right of the head
    for i = 1:length(input)
        push!(tape_right, parse(Int, input[i]))
    end
    state = init_state
    return state, tape_left, tape_right
end

"""
    read_tape(tape_right)

Reads a tape and returns the current value.

Input
- `tape_right`::Deque{Int}() : values for the stack to the right of the head

Output
- `read_cell`::String : value for the current cell being read by the head
"""
function read_tape(tape_right)
    read_cell = front(tape_right)
    return read_cell
end

"""
    get_instruction(state, read_cell, program)

Inputs
- `state`::String : curent state of the Turing machine
- `read_cell`::String : value for the current cell being read by the head
- `program`::Dict{Any,Any} with `m` entries: dictionary with keys of [states,read_cells] and values of [next_state,write_cell,movement]

Outputs
- `next_state`::String : next state for the Turing machine to move to
- `write_cell`::String : value for the head to write on the current cell
- `movement`::String : movement instruction for the head (left="<", right=">", any other symbol doesn't move)
"""
function get_instruction(state, read_cell, program)
    instruction = program[(string(state), string(read_cell))]
    next_state = instruction[1]
    write_cell = instruction[2]
    movement = instruction[3]
    return next_state, write_cell, movement
end

"""
    write_move!(movement, write_cell, tape_left, tape_right)

Performs the operations of writing at the current position then moving the head left or right.

Inputs
- `movement`::String : movement instruction for the head (left="<", right=">", any other symbol doesn't move)
- `write_cell`::String : value for the head to write on the current cell
- `tape_left`::Deque{Int} : values for the stack to the left of the head
- `tape_right`::Deque{Int} : values for the stack to the right of the head

Outputs
- `tape_left`::Deque{Int} : updated values for the stack to the left of the head (after writing/movement)
- `tape_right`::Deque{Int} : updated values for the stack to the right of the head (after writing/movement)
"""
function write_move!(movement, write_cell, tape_left, tape_right)
    if isempty(tape_right)
        return tape_left, tape_right
    end
    popfirst!(tape_right)
    pushfirst!(tape_right, parse(Int, write_cell))
    if movement == "<"
        if isempty(tape_left)
            pushfirst!(tape_right, "_")
        else
            carry = pop!(tape_left)
            pushfirst!(tape_right, carry)
        end
    elseif movement == ">"
        if isempty(tape_right)
            push!(tape_left, "_")
        else
            carry = popfirst!(tape_right)
            push!(tape_left, carry)
        end
    end
    return tape_left, tape_right
end

"""
    simulate(state, program, tape_left, tape_right)

Simulates one step of the Turing machine: reading, writing, and moving the head.

Inputs
- `state`::String : curent state of the Turing machine
- `program`::Dict{Any,Any} with `m` entries: dictionary with keys of [states,read_cells] and values of [next_state,write_cell,movement]
- `tape_left`::Deque{Int} : values for the stack to the left of the head
- `tape_right`::Deque{Int} : values for the stack to the right of the head

Outputs
- `state`::String : updated state of the Turing machine after one simulation step
- `tape_left`::Deque{Int} : updated values for the stack to the left of the head after one simulation step
- `tape_right`::Deque{Int} : updated values for the stack to the right of the head after one simulation step
"""
function simulate(state, program, tape_left, tape_right)
    if isempty(tape_right)
        read_cell = "_"
    else
        read_cell = read_tape(tape_right)
    end
    state, write_cell, movement = get_instruction(state, read_cell, program)
    tape_left, tape_right = write_move!(movement, write_cell, tape_left, tape_right)
    return state, tape_left, tape_right
end


end # module
