function part1(input)
    instructions = parse_line.(eachline(input))
    return run_program(instructions, part = 1)
end

function part2(input)
    instructions = parse_line.(eachline(input))
    return run_program(instructions, part = 2)
end

function run_program(instructions; part)
    counter = 1
    registers = Dict(register => 0 for register in (:a, :b, :c, :d))
    if part == 2
        registers[:c] = 1
    end
    while counter <= length(instructions)
        (instruction, args) = instructions[counter]
        if instruction == :cpy
            registers[last(args)] = get_value(registers, first(args))
        elseif instruction == :inc
            registers[only(args)] += 1
        elseif instruction == :dec
            registers[only(args)] -= 1
        else
            if get_value(registers, first(args)) != 0
                counter += last(args)
                counter -= 1
            end
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
    ('1' <= word[1] <= '9' || word[1] == '-') && return parse(Int, word)
    return Symbol(word)
end
