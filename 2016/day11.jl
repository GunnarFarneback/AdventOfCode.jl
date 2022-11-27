function part1(input)
    configuration = parse_input(input)
    return move_items(configuration)
end

function part2(input)
    configuration = parse_input(input)
    append!(configuration, [1, 1, 1, 1])
    return move_items(configuration)
end

function move_items(configuration)
    state = vcat(1, configuration)
    visited = Set([state])
    queue = [(0, state)]
    while !isempty(queue)
        moves, state = popfirst!(queue)
        floor = state[1]
        items = findall(state .== floor)
        for next_floor = [floor - 1, floor + 1]
            (next_floor < 1 || next_floor > 4) && continue
            for i = 2:length(items)
                for j = i:length(items)
                    new_state = copy(state)
                    new_state[1] = next_floor
                    new_state[items[i]] = next_floor
                    new_state[items[j]] = next_floor
                    all(==(4), new_state) && return moves + 1
                    chip_fried(new_state) && continue
                    new_state in visited && continue
                    push!(queue, (moves + 1, new_state))
                    push!(visited, new_state)
                end
            end
        end
    end
    @assert false
end

function chip_fried(state)
    generator_found = falses(4)
    unprotected_chip_found = falses(4)
    for i = 2:2:length(state)
        if state[i] != state[i + 1]
            unprotected_chip_found[state[i + 1]] = true
        end
        generator_found[state[i]] = true
    end
    return any(generator_found .& unprotected_chip_found)
end

function parse_input(input)
    n = 1
    isotopes = Dict{String, Int}()
    configuration = Int[]
    for (floor, line) in enumerate(eachline(input))
        for thing in split(line, " a ")[2:end]
            is_chip = '-' in thing
            if is_chip
                isotope = first(split(thing, "-"))
            else
                isotope = first(split(thing, " "))
            end
            if !haskey(isotopes, isotope)
                isotopes[isotope] = n
                n += 1
                append!(configuration, [0, 0])
            end
            configuration[2 * isotopes[isotope] - !is_chip] = floor
        end
    end
    return configuration
end
