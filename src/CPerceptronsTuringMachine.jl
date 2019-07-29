"""
    perceptron_stack(n_bits)

Sets up a `perceptron_stack` with `n_bits` of perceptron states.
"""
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

"""
    is_stack_empty(perceptron_stack::perceptron_stack)

Checks if `perceptron_stack` is empty.
"""
function is_stack_empty(perceptron_stack::perceptron_stack)
    return perceptron_stack.n_bits == 0
end

"""
    push_stack!(stack::perceptron_stack, bit)

Pushes a `bit` to a `perceptron_stack`.
"""
function push_stack!(stack::perceptron_stack, bit)
    if typeof(bit) != Int
        return stack
    else
        append!(stack.bits, perceptron(0, 1, bit))
        stack.n_bits += 1
    end
    return stack
end

"""
    pop_stack!(stack::perceptron_stack)

Pops a bit from a `perceptron_stack`.
"""
function pop_stack!(stack::perceptron_stack)
    bit = stack.bits[stack.n_bits]
    deleteat!(stack.bits, stack.n_bits)
    stack.n_bits -= 1
    return stack, bit
end

"""
    set_up_perceptron(init_state, input)

Performs initial set-up for the simulation of single tape using perceptron stacks.
"""
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

"""
    read_tape(tape_right::perceptron_stack)

Reads the first cell on a right-handed tape/`perceptron_stack`.
"""
function read_tape(tape_right::perceptron_stack)
    read_cell = tape_right.bits[tape_right.n_bits]
    return read_cell
end

"""
    write_move!(movement, write_cell, tape_left::perceptron_stack, tape_right::perceptron_stack)

`write_move!` for `perceptron_stack`s.
"""
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


"""
    simulate(state, program, tape_left::perceptron_stack, tape_right::perceptron_stack)

Simulate for `perceptron_stack`s.
"""
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
