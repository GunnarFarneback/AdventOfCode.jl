function part1(input)
    fields, your_ticket, nearby_tickets = parse_input(input)
    valid_values = find_valid_values(fields)
    return sum(value
               for value in reduce(vcat, nearby_tickets)
               if value ∉ valid_values)
end

function part2(input)
    fields, your_ticket, nearby_tickets = parse_input(input)
    valid_values = find_valid_values(fields)
    filter!(numbers -> all(number in valid_values for number in numbers),
            nearby_tickets)
    possible_assignments = Dict(key => find_field_number(nearby_tickets, value)
                                for (key, value) in fields)
    assignments = Dict{String, Int}()
    while !isempty(possible_assignments)
        assigned = nothing
        for (key, value) in possible_assignments
            if length(value) == 1
                assigned = only(value)
                assignments[key] = assigned
                delete!(possible_assignments, key)
                break
            end
        end
        @assert !isnothing(assigned)
        for value in values(possible_assignments)
            filter!(!=(assigned), value)
        end
    end

    return prod(Int[your_ticket[value]
                    for (key, value) in assignments
                    if startswith(key, "departure")])
end

function find_field_number(nearby_tickets, ranges)
    possible_fields = Set(1:length(first(nearby_tickets)))
    for ticket in nearby_tickets
        bad_fields = Set{Int}()
        for field in possible_fields
            if !any(ticket[field] in range for range in ranges)
                push!(bad_fields, field)
            end
            possible_fields = setdiff(possible_fields, bad_fields)
        end
    end
    return possible_fields
end

function find_valid_values(fields)
    valid_values = Set{Int}()
    for range in reduce(vcat, values(fields))
        for i in range
            i in valid_values || push!(valid_values, i)
        end
    end
    return valid_values
end

function parse_input(input)
    fields = Dict{String, Vector{UnitRange{Int}}}()
    field_data, your_ticket, nearby_tickets = split(read(input, String), "\n\n")
    for line in split(field_data, "\n")
        name, a, b, c, d = match(r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)",
                                 line).captures
        fields[name] = [parse(Int, a):parse(Int, b),
                        parse(Int, c):parse(Int, d)]
    end

    your = get_numbers(last(split(your_ticket, "\n")))

    nearby = get_numbers.(split(nearby_tickets, "\n", keepempty = false)[2:end])
    
    return fields, your, nearby
end

get_numbers(line) = parse.(Int, split(line, ","))
