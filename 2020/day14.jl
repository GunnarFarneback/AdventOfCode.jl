function part1(input)
    and_mask = 2^36 - 1
    or_mask = 0
    memory = Dict{Int, Int}()
    for line in readlines(input)
        if startswith(line, "mask")
            mask = last(split(line, " = "))
            and_mask = parse(Int, replace(mask, "X" => "1"), base = 2)
            or_mask = parse(Int, replace(mask, "X" => "0"), base = 2)
        else
            address_string, value_string = match(r"mem\[(\d+)\] = (\d+)",
                                                 line).captures
            address = parse(Int, address_string)
            value = parse(Int, value_string)
            memory[address] = (value & and_mask) | or_mask
        end
    end
    return sum(values(memory))
end

function part2(input)
    and_mask = 2^36 - 1
    or_mask = 0
    float_bits = Int[]
    memory = Dict{Int, Int}()
    for line in readlines(input)
        if startswith(line, "mask")
            mask = last(split(line, " = "))
            or_mask = parse(Int, replace(mask, "X" => "0"), base = 2)
            and_mask = parse(Int, replace(replace(mask, "0" => "1"),
                                          "X" => "0"), base = 2)
            float_bits = 36 .- findall(split(mask, "") .== "X")
        else
            address_string, value_string = match(r"mem\[(\d+)\] = (\d+)",
                                                 line).captures
            address = parse(Int, address_string)
            value = parse(Int, value_string)
            address |= or_mask
            for i = 0:((1 << length(float_bits)) - 1)
                address &= and_mask
                for j = 1:length(float_bits)
                    if (i & (1 << (j - 1))) != 0
                        address |= 1 << (float_bits[j])
                    end
                end
                memory[address] = value
            end
        end
    end
    return sum(values(memory))
end
