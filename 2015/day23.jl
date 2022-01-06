mutable struct State
    a::Int
    b::Int
end

function part1(input)
    program = parse_line.(eachline(input))
    return run(program, a = 0)
end

function part2(input)
    program = parse_line.(eachline(input))
    return run(program, a = 1)
end

function parse_line(line)
    parts = split(replace(line, "," => ""))
    instruction = Symbol(first(parts))
    instruction == :jmp && return (instruction, parse(Int, parts[2]))
    if instruction == :jie || instruction == :jio
        return (instruction, Symbol(parts[2]), parse(Int, parts[3]))
    end
    return (instruction, Symbol(parts[2]))
end

function run(program; a)
    state = State(a, 0)
    n = 1
    while n <= length(program)
        instruction, arguments... = program[n]
        if instruction == :hlf
            setfield!(state, first(arguments), getfield(state, first(arguments)) >> 1)
            n += 1
        elseif instruction == :tpl
            setfield!(state, first(arguments), getfield(state, first(arguments)) * 3)
            n += 1
        elseif instruction == :inc
            setfield!(state, first(arguments), getfield(state, first(arguments)) + 1)
            n += 1
        elseif instruction == :jmp
            n += first(arguments)
        elseif instruction == :jie
            n += getfield(state, first(arguments)) % 2 == 0 ? last(arguments) : 1
        elseif instruction == :jio
            n += getfield(state, first(arguments)) == 1 ? last(arguments) : 1
        end
    end
    return state.b
end
