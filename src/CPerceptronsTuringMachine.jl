include("ConstructedPerceptrons.jl")

mutable struct perceptron_stack
    bits
    b
    function perceptron_stack(n_bits)
        bits = []
        b = 1
        for i = 1:n_bits
            append!(bits, perceptron(0, 1, 0))
        end
    end
end
