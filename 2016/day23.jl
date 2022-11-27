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
    if part == 1
        registers[:a] = 7
    else
        registers[:a] = 12
    end
    while counter <= length(instructions)
        (instruction, args) = instructions[counter]
        if (counter <= length(instructions) - 5
            && instructions[counter:(counter + 5)] == [(:cpy, [:b, :c]),
                                                       (:inc, [:a]),
                                                       (:dec, [:c]),
                                                       (:jnz, Any[:c, -2]),
                                                       (:dec, [:d]),
                                                       (:jnz, Any[:d, -5])])
            registers[:a] += registers[:b] * registers[:d]
            registers[:c] = registers[:d] = 0
            counter += 6
            continue
        end

        if (counter <= length(instructions) - 2
            && instructions[counter:(counter + 2)] == [(:dec, [:d]),
                                                       (:inc, [:c]),
                                                       (:jnz, Any[:d, -2])])
            registers[:c] += registers[:d]
            registers[:d] = 0
            counter += 3
            continue
        end

        if (counter <= length(instructions) - 5
            && instructions[counter:(counter + 5)] == [(:cpy, Any[73, :d]),
                                                       (:inc, [:a]),
                                                       (:dec, [:d]),
                                                       (:jnz, Any[:d, -2]),
                                                       (:dec, [:c]),
                                                       (:jnz, Any[:c, -5])])
            registers[:a] += 73 * registers[:c]
            registers[:c] = registers[:d] = 0
            counter += 6
            continue
        end

        if instruction == :cpy
            if last(args) isa Symbol
                registers[last(args)] = get_value(registers, first(args))
            end
        elseif instruction == :inc
            if only(args) isa Symbol
                registers[only(args)] += 1
            end
        elseif instruction == :dec
            if only(args) isa Symbol
                registers[only(args)] -= 1
            end
        elseif instruction == :jnz
            if get_value(registers, first(args)) != 0
                counter += get_value(registers, last(args))
                counter -= 1
            end
        elseif instruction == :tgl
            target = counter + get_value(registers, only(args))
            if 1 <= target <= length(instructions)
                target_instruction, target_args = instructions[target]
                target_instruction = Dict(:inc => :dec, :dec => :inc, :tgl => :inc,
                                          :cpy => :jnz, :jnz => :cpy)[target_instruction]
                instructions[target] = (target_instruction, target_args)
            end
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
