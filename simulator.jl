using DataStructures
using DelimitedFiles

# Read Input / Change value of current input (or do nothing), Move L or R or do nothing
# e.g. 1/0, L = if current cell value is 1, change it to 0, then move left
# e.g. 0/1, . = if current cell value is 0, change it to 1, then don't move

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
"""
function load_program(file_name)
    program_file = readdlm("example_program_1.txt")
    rows, cols = size(program_file)
    program = Dict{Any,Any}()
    init_state = []
    halt_state = []
    for i = 1:rows
        if program_file[i,1] == "//"
            continue
        else
            if program_file[i,1] == "init:"
                push!(init_state, program_file[i,2])
            elseif program_file[i,1] == "halt:"
                push!(halt_state, program_file[i,2])
            else
                card = split(program_file[i,1], r",")
                state_read = (String(card[1]),String(card[2]))
                instruction = (String(card[3]),String(card[4]),String(card[5]))
                program[state_read] = instruction
            end
        end
    end
    return program, init_state[], halt_state[]
end

"""
    set_up(input)

Performs initial set-up for the simulation of single tape. The `length(input)` must be equal of greater
than 1. The input will be placed on tape to the right of the head.

Input
- `input`::`n`-element Array{Char, 1} : initial data to insert to the right of the head

Output
- `tape_left`::Deque{Int} : initial values for the stack to the left of the head
- `tape_right`::Deque{Int} : initial values for the stack to the right of the head
"""
function set_up(input)
    # set up two stacks to simulate a single tape
    tape_left = Deque{Int}() # simulates tape lying to the left of the head
    tape_right = Deque{Int}() # simulates tape lying to the right of the head

    for i = 1:length(input)
        push!(tape_right, parse(Int, input[i]))
    end

    return tape_left, tape_right
end
