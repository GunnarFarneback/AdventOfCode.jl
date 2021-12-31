function part1(input)
    monad = parse_input(input)
    output = run(monad, part = 1)
    return maximum(v for (k, v) in output if last(k) == 0)
end

function part2(input)
    monad = parse_input(input)
    output = run(monad, part = 2)
    return minimum(v for (k, v) in output if last(k) == 0)
end

parse_input(input) = parse_line.(eachline(input))

function parse_line(line)
    parts = split(line)
    instruction = Symbol(parts[1])
    target = Symbol(parts[2])
    if length(parts) < 3
        value = nothing
    else
        if 'w' <= first(parts[3]) <= 'z'
            value = Symbol(parts[3])
        else
            value = parse(Int, parts[3])
        end
    end
    return (instruction, target, value)
end

function run(monad; part)
    states = Dict((0, 0, 0, 0) => 0)
    for (j, (instruction, target, value)) in enumerate(monad)
        # @show j instruction target value length(states)
        # if instruction == :inp
        #     @show length(unique(state[4] for state in keys(states)))
        # end
        next_states = empty(states)
        for ((w, x, y, z), input) in states
            if instruction == :inp
                @assert target == :w
                for i = 1:9
                    next_state = (i, x, y, z)
                    next_input = 10 * input + i
                    if !haskey(next_states, next_state)
                        next_states[next_state] = next_input
                    elseif part == 1
                        next_states[next_state] =
                            max(next_states[next_state], next_input)
                    else
                        next_states[next_state] =
                            min(next_states[next_state], next_input)
                    end
                end
            else
                v = get_value(w, x, y, z, value)
                if instruction == :add
                    target == :w && (w += v)
                    target == :x && (x += v)
                    target == :y && (y += v)
                    target == :z && (z += v)
                elseif instruction == :mul
                    target == :w && (w *= v)
                    target == :x && (x *= v)
                    target == :y && (y *= v)
                    target == :z && (z *= v)
                elseif instruction == :div
                    @assert v != 0
                    target == :w && (w ÷= v)
                    target == :x && (x ÷= v)
                    target == :y && (y ÷= v)
                    target == :z && (z ÷= v)
                elseif instruction == :mod
                    @assert v > 0
                    target == :w && (w %= v)
                    target == :x && (x %= v)
                    target == :y && (y %= v)
                    target == :z && (z %= v)
                elseif instruction == :eql
                    target == :w && (w = w == v)
                    target == :x && (x = x == v)
                    target == :y && (y = y == v)
                    target == :z && (z = z == v)
                end
                next_state = (w, x, y, z)
                if !haskey(next_states, next_state)
                    next_states[next_state] = input
                elseif part == 1
                    next_states[next_state] =
                        max(next_states[next_state], input)
                else
                    next_states[next_state] =
                        min(next_states[next_state], input)
                end
            end
        end
        states = next_states
    end
    return states
end

function get_value(w::Int, x::Int, y::Int, z::Int, value::Symbol)
    value == :w && return w
    value == :x && return x
    value == :y && return y
    return z
end

get_value(w::Int, x::Int, y::Int, z::Int, value::Int) = value
