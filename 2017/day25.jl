function part1(input)
    state, n, machine = parse_input(input)
    tape = Dict{Int, Int}()
    pos = 0
    for i = 1:n
        state, dir, value = machine[state][1 + get(tape, pos, 0)]
        tape[pos] = value
        pos += dir
    end
    return sum(values(tape))
end

function part2(input)
end

function parse_input(input)
    start_state = Symbol(readline(input)[end - 1])
    n = parse(Int, split(readline(input), " ")[end - 1])
    machine = Dict{Symbol, NTuple{2, Tuple{Symbol, Int, Int}}}()
    while !eof(input)
        readline(input)
        state = Symbol(readline(input)[end - 1])
        value0, next_state0, dir0, next_value0 = parse_rule(input)
        value1, next_state1, dir1, next_value1 = parse_rule(input)
        @assert value0 == 0 && value1 == 1
        machine[state] = ((next_state0, dir0, next_value0),
                          (next_state1, dir1, next_value1))
    end
    return start_state, n, machine
end

function parse_rule(input)
    value = parse(Int, readline(input)[(end - 1):(end - 1)])
    next_value = parse(Int, readline(input)[(end - 1):(end - 1)])
    dir = -1
    if last(split(readline(input), " ")) == "right."
        dir = 1
    end
    next_state = Symbol(readline(input)[end - 1])
    return value, next_state, dir, next_value
end
