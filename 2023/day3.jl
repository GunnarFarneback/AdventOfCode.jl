function part1(input)
    m = parse_input(input)
    s = 0
    for i = 2:(size(m, 1) - 1)
        n = 0
        current_near_symbol = false
        parsing_number = false
        number_near_symbol = false
        for j = 1:size(m, 2)
            last_near_symbol = current_near_symbol
            current_near_symbol = any(c -> (c != '.' && !isdigit(c)),
                                      (m[i - 1, j], m[i, j], m[i + 1, j]))
            if isdigit(m[i, j])
                n = 10 * n + (m[i, j] - '0')
                if !parsing_number
                    number_near_symbol = last_near_symbol
                    parsing_number = true
                end
                number_near_symbol |= current_near_symbol
            else
                if parsing_number
                    parsing_number = false
                    if number_near_symbol || current_near_symbol
                        s += n
                    end
                end
                n = 0
            end
        end
    end
    return s
end

function part2(input)
    m = parse_input(input)
    asterisk_numbers = Dict{Tuple{Int, Int}, Vector{Int}}()
    for i = 2:(size(m, 1) - 1)
        n = 0
        current_near_asterisk = Tuple{Int, Int}[]
        parsing_number = false
        number_near_asterisk = Tuple{Int, Int}[]
        for j = 1:size(m, 2)
            last_near_asterisk = current_near_asterisk
            current_near_asterisk = [(i′, j) for i′ in (i - 1):(i + 1) if m[i′, j] == '*']
            if isdigit(m[i, j])
                n = 10 * n + (m[i, j] - '0')
                if !parsing_number
                    append!(number_near_asterisk, last_near_asterisk)
                    parsing_number = true
                end
                append!(number_near_asterisk, current_near_asterisk)
            else
                if parsing_number
                    parsing_number = false
                    append!(number_near_asterisk, current_near_asterisk)
                    for pos in number_near_asterisk
                        push!(get!(asterisk_numbers, pos, Int[]), n)
                    end
                    number_near_asterisk = Tuple{Int, Int}[]
                    n = 0
                end
            end
        end
    end
    return sum(prod(v) for v in values(asterisk_numbers) if length(v) == 2)
end

function parse_input(input)
    x = permutedims(stack(collect.(readlines(input))))
    m = fill('.', size(x) .+ 2)
    m[2:end-1,2:end-1] .= x
    return m
end
