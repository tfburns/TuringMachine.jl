include("src/ConstructedPerceptrons.jl")

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

function push_perceptron_stack!(perceptron_stack, bit)
    append!(perceptron_stack.bits, perceptron(0, 1, bit))
    perceptron_stack.n_bits += 1
    return perceptron_stack
end

function pop_perceptron_stack!(perceptron_stack)
    bit = perceptron_stack.bits[perceptron_stack.n_bits]
    deleteat!(perceptron_stack.bits, perceptron_stack.n_bits)
    perceptron_stack.n_bits -= 1
    return perceptron_stack, bit
end

function
