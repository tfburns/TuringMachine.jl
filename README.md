# Turing machine simulator
Julia-based Turing machine simulator

Turing machines were invented in 1936 by British mathematician and computing pioneer Alan Turing. They are machines which can compute any algorithm. Granted, they may be verbose or inefficient compared to other computing strategies, but nevertheless they are capable of computing arbitrary algorithms.

This simulation of a Turing machine uses Tibor Radó cards to store instructions to make programs. The machine uses a single tape, simulated by two stacks - one storing information to the left of the head, and one storing information to the right of the head. For programmatic convenience in this simulation, the stack storing information to the right of the head also holds the cell which the head is currently reading from and at the position of.

Files
- `simulator.jl` holds the main simulation and helper functions.
- `example.jl` shows an example of how to read in a program, initial data, and then simulate the program by calling functions from `simulator.jl`.
- `example_program_1.txt` is a set of Radó cards for a Turing machine to compute whether a binary number is divisible by 3. Blank lines and lines starting with `//` are discarded. `init` is the initial starting state, and `halt` is the halting state. Instructions may appear in arbitrary order with the format: `state, value of current cell, state to move to, value to replace in the first cell, movement on the tape`, e.g. 
- `example_input_1.txt` is a binary input string which is placed starting from under the reading head and then extending right-ward from the head.
