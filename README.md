# Turing Machine Simulator v0.1.0

| Travis Status | AppVeyor Status | Code Test Coverage |
| :----: | :----: | :----: |
| [![Travis Build Status](https://travis-ci.org/tfburns/TuringMachine.jl.svg?branch=master)](https://travis-ci.org/tfburns/TuringMachine.jl) | ![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/tfburns/TuringMachine-jl) | [![codecov.io](http://codecov.io/github/tfburns/TuringMachine.jl/coverage.svg?branch=master)](http://codecov.io/github/tfburns/TuringMachine.jl?branch=master) |

Turing machines were invented in 1936 by British mathematician and computing pioneer Alan Turing. They are machines which can compute any algorithm. Granted, they may be verbose or inefficient compared to other computing strategies, but nevertheless they are capable of computing arbitrary algorithms.

This simulation of a Turing machine uses Tibor Radó cards to store instructions to make programs. The machine uses a single tape, simulated by two stacks - one storing information to the left of the head, and one storing information to the right of the head. For programmatic convenience in this simulation, the stack storing information to the right of the head also holds the cell which the head is currently reading from and at the position of.

Files
- `TuringMachine.jl` holds the main simulation and helper functions.
- `example.jl` shows an example of how to read in a program, initial data, and then simulate the program by calling functions from `TuringMachine.jl`.
- `example_program_1.txt` is a set of Radó cards for a Turing machine to compute whether a binary number is divisible by 3. Blank lines and lines starting with `//` are discarded. `init` is the initial starting state, and `halt` is a halting state. Instructions may appear in arbitrary order but with the format: `state, value of current cell, state to move to, value to replace in the first cell, movement on the tape`, e.g. `q2,0,q1,0,>` means: when at state `q2` and the head reads a `0`, write a `0` and go to state `q1`, then move the tape one step `>` (to the right).
- `example_input_1.txt` is a binary input string which is placed starting from under the reading head and then extending right-ward from the head.
