function part1(input)
    instructions = parse_line.(eachline(input))
    init = 0
    while !run_program(instructions, init, 1000)
        init += 1
    end
    return init
end

function part2(input)
end

function run_program(instructions, init, required_length)
    counter = 1
    registers = Dict(register => 0 for register in (:a, :b, :c, :d))
    registers[:a] = init
    out = Int[]
    while counter <= length(instructions)
        (instruction, args) = instructions[counter]
        if instruction == :cpy
            registers[last(args)] = get_value(registers, first(args))
        elseif instruction == :inc
            registers[only(args)] += 1
        elseif instruction == :dec
            registers[only(args)] -= 1
        elseif instruction == :jnz
            if get_value(registers, first(args)) != 0
                counter += get_value(registers, last(args))
                counter -= 1
            end
        elseif instruction == :out
            push!(out, get_value(registers, first(args)))
            length(out) == required_length && return true
            out[end] != (length(out) + 1) % 2 && return false
        else
            @assert false
        end
        counter += 1
    end
    return registers[:a]
end

get_value(registers, value::Int) = value
get_value(registers, value::Symbol) = registers[value]

function parse_line(line)
    words = split(line, " ")
    return (Symbol(words[1]), symbol_or_number.(words[2:end]))
end

function symbol_or_number(word)
    ('0' <= word[1] <= '9' || word[1] == '-') && return parse(Int, word)
    return Symbol(word)
end
