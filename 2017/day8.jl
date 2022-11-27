function part1(input)
    return run_program(input, 1)
end

function part2(input)
    return run_program(input, 2)
end

function run_program(input, part)
    registers = Dict{String, Int}()
    max_register_value = 0
    operations = Dict("inc" => +,
                      "dec" => -)
    predicates = Dict("<" => <,
                      "<=" => <=,
                      ">" => >,
                      ">=" => >=,
                      "==" => ==,
                      "!=" => !=)
    for line in readlines(input)
        reg1, op, val1, _, reg2, pred, val2 = split(line, " ")
        if predicates[pred](get(registers, reg2, 0), parse(Int, val2))
            new_value = operations[op](get(registers, reg1, 0),
                                       parse(Int, val1))
            registers[reg1] = new_value
            max_register_value = max(max_register_value, new_value)
        end
    end
    return (part == 1) ? maximum(values(registers)) : max_register_value
end
