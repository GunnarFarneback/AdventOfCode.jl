function part1(input)
    instructions = Dict(parse_line.(eachline(input))...)
    return Int(evaluate(instructions, :a))
end

function part2(input)
    instructions = Dict(parse_line.(eachline(input))...)
    b = evaluate(instructions, :a)
    return Int(evaluate(instructions, :a, Dict(:b => b)))
end

function parse_line(line)
    operations = Dict("OR" => |,
                      "AND" => &,
                      "NOT" => ~,
                      "LSHIFT" => <<,
                      "RSHIFT" => >>)
    parts = split(line)
    output = Symbol(parts[end])
    if length(parts) > 3
        operation = operations[parts[end - 3]]
    else
        operation = identity
    end
    if length(parts) <= 4
        input = [symbol_or_number(parts[end - 2])]
    else
        input = symbol_or_number.(parts[[1, 3]])
    end
    return output => (operation, input)
end

function symbol_or_number(word)
    if '0' <= first(word) <= '9'
        return parse(UInt16, word)
    end
    return Symbol(word)
end

evaluate(instructions, value::UInt16, cache) = value

function evaluate(instructions, variable::Symbol,
                  cache = Dict{Symbol, UInt16}())
    if !haskey(cache, variable)
        operation, inputs = instructions[variable]
        values = evaluate.(Ref(instructions), inputs, Ref(cache))
        cache[variable] = operation(values...)
    end
    return cache[variable]
end

