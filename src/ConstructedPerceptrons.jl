"""
    perceptron(inputs, weights, bias)

Computes the output of a perceptron with threshold of `0` given some `inputs`, `weights`, and `bias`.
"""
function perceptron(inputs, weights, bias)
    if sum(inputs * weights) + bias > 0
        return 1
    else
        return 0
    end
end

"""
    perceptron_store(x)

Computes the identity of a binary input `x`.
"""
function perceptron_store(x)
    return perceptron(x,1,0)
end

"""
    not_gate(x)

Computes ¬`x` using a perceptron with constructed biases and weights.
"""
function not_gate(x)
    return perceptron(x,-2,1)
end

"""
    and_gate(x,y)

Computes `x`∧`y` using a perceptron with constructed biases and weights.
"""
function and_gate(x,y)
    return perceptron([x,y],1,-1)

"""
    or_gate(x,y)

Computes `x`∨`y` using a perceptron with constructed biases and weights.
"""
function or_gate(x,y)
    return perceptron([x,y],1,0)
end

"""
    nor_gate(x,y)

Computes ¬(`x`∨`y`) using a perceptron with constructed biases and weights.
"""
function nor_gate(x,y)
    return perceptron([x,y],-2,1)
end

"""
    nand_gate(x,y)

Computes ¬(`x`∧`y`) using a perceptron with constructed biases and weights.
"""
function nand_gate(x,y)
    return perceptron([x,y],-2,3)
end


"""
    xor_gate(x,y)

Computes `x` XOR `y` using NAND gates.
"""
function xor_gate(x,y)
    nand_1 = nand_gate(x,y)
    nand_2_x = nand_gate(x,nand_1)
    nand_2_y = nand_gate(y,nand_1)
    return nand_gate(nand_2_x,nand_2_y)
end

"""
    xnor_gate(x,y)

Computes `x` XNOR `y` using NAND gates.
"""
function xnor_gate(x,y)
    nand_1_x = nand_gate(x,x)
    nand_1_y = nand_gate(y,y)
    nand_2_x = nand_gate(nand_1_x,y)
    nand_2_y = nand_gate(nand_1_y,x)
    return nand_gate(nand_2_x,nand_2_y)
end

"""
    mux_gate(x,y,s)

Computes (`x`∧¬`s`)∨(`y`∧`s`), thus outputting whatever the value `x` or `y` is
based on the selection of `s`. This is computed using NAND gates.
"""
function mux_gate(x,y,s)
    nand_s = nand_gate(s,s)
    nand_x = nand_gate(x,nand_s)
    nand_y = nand_gate(y,s)
    return nand_gate(nand_x,nand_y)
end

"""
    demux_gate(x,s)

Computes the inverse of mux_gate, thus outputting the value `x` in position `a` or `b`
based on the selection of `s`. This is computed using NAND gates.
"""
function demux_gate(x,s)
    nand_s = nand_gate(s,s)
    nand_1_a = nand_gate(x,nand_s)
    nand_1_b = nand_gate(x,s)
    a = nand_gate(nand_1_a,nand_1_a)
    b = nand_gate(nand_1_b,nand_1_b)
    return a, b
end

"""
    bit_sum(x,y)

Computes the bitwise sum of `x` and `y` using NAND gates.
"""
function bit_sum(x,y)
    nand_1 = nand_gate(x,y)
    nand_2_x = nand_gate(x,nand_1)
    nand_2_y = nand_gate(y,nand_1)
    sum = nand_gate(nand_2_x,nand_2_y)
    carry = nand_gate(nand_1,nand_1)
    return sum, carry
end

"""
    bit_prod(x,y)

Computes the bitwise product of `x` and `y` using NAND and XOR gates.
"""
function bit_prod(x,y)
    nand_1 = nand_gate(x,y)
    nand_2_x = nand_gate(x,nand_1)
    nand_2_y = nand_gate(y,nand_1)
    prod = xor_gate(nand_2_x,nand_2_y)
    carry = nand_gate(nand_1,nand_1)
    return prod, carry
end
