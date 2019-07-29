include("ConstructedPerceptrons.jl")

mutable struct perceptron_stack
    n_bits
    bits
    function perceptron_stack(n_bits=0)
        n_bits = n_bits
        bits = []
        for i = 1:n_bits
            append!(bits, perceptron(0, 1, 0))
        end
        return new(n_bits, bits)
    end
end

function is_stack_empty(perceptron_stack::perceptron_stack)
    return perceptron_stack.n_bits == 0
end

function push_stack!(stack::perceptron_stack, bit)
    if typeof(bit) != Int
        return stack
    else
        append!(stack.bits, perceptron(0, 1, bit))
        stack.n_bits += 1
    end
    return stack
end

function pop_stack!(stack::perceptron_stack)
    bit = stack.bits[stack.n_bits]
    deleteat!(stack.bits, stack.n_bits)
    stack.n_bits -= 1
    return stack, bit
end

function set_up_perceptron(init_state, input)
    # set up two stacks to simulate a single tape
    tape_left = perceptron_stack() # simulates tape lying to the left of the head
    tape_right = perceptron_stack() # simulates tape lying to the right of the head
    for i = 1:length(input)
        push_stack!(tape_right, parse(Int, input[i]))
    end
    state = init_state
    return state, tape_left, tape_right
end

function read_tape(tape_right::perceptron_stack)
    read_cell = tape_right.bits[tape_right.n_bits]
    return read_cell
end

function write_move!(movement, write_cell, tape_left::perceptron_stack, tape_right::perceptron_stack)
    if is_stack_empty(tape_right)
        return tape_left, tape_right
    end
    pop_stack!(tape_right)
    push_stack!(tape_right, parse(Int, write_cell))
    if movement == "<"
        if is_stack_empty(tape_left)
            push_stack!(tape_right, "_")
        else
            carry = pop_stack!(tape_left)
            push_stack!(tape_right, carry)
        end
    elseif movement == ">"
        if is_stack_empty(tape_right)
            push_stack!(tape_left, "_")
        else
            carry = pop_stack!(tape_right)
            push_stack!(tape_left, carry)
        end
    end
    return tape_left, tape_right
end

function simulate(state, program, tape_left::perceptron_stack, tape_right::perceptron_stack)
    if is_stack_empty(tape_right)
        read_cell = "_"
    else
        read_cell = read_tape(tape_right)
    end
    state, write_cell, movement = get_instruction(state, read_cell, program)
    tape_left, tape_right = write_move!(movement, write_cell, tape_left, tape_right)
    return state, tape_left, tape_right
end
