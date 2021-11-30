function part1(input, number_of_days = "0")
    instructions = readlines(input)
    black_tiles = get_initial_black_tiles(instructions)
    return length(black_tiles)
end

function part2(input, number_of_days = "100")
    instructions = readlines(input)
    black_tiles = get_initial_black_tiles(instructions)
    for _ = 1:parse(Int, number_of_days)
        black_tiles = flip_tiles(black_tiles)
    end
    return length(black_tiles)
end

function get_initial_black_tiles(instructions)
    black_tiles = Set{Tuple{Int, Int}}()
    for instruction in instructions
        location = parse_instruction(instruction)
        if location in black_tiles
            delete!(black_tiles, location)
        else
            push!(black_tiles, location)
        end
    end
    return black_tiles
end

function parse_instruction(instruction)
    e, ne = 0, 0
    i = 1
    while i <= length(instruction)
        if instruction[i] == 'w'
            e -= 1
            i += 1
        elseif instruction[i] == 'e'
            e += 1
            i += 1
        elseif instruction[i] == 'n'
            if instruction[i + 1] == 'w'
                e -= 1
                ne += 1
                i += 2
            elseif instruction[i + 1] == 'e'
                ne += 1
                i += 2
            end
        elseif instruction[i] == 's'
            if instruction[i + 1] == 'w'
                ne -= 1
                i += 2
            elseif instruction[i + 1] == 'e'
                e += 1
                ne -= 1
                i += 2
            end
        end
    end
    return e, ne
end

function flip_tiles(tiles)
    neighbor_counts = Dict{Tuple{Int, Int}, Int}()
    for tile in tiles
        neighbor_counts[tile] = get(neighbor_counts, tile, 0) + 1
        for Δ in ((1, 0), (-1, 0), (-1, 1), (0, 1), (0, -1), (1, -1))
            neighbor_counts[tile .+ Δ] = get(neighbor_counts, tile .+ Δ, 0) + 2
        end
    end
    new_tiles = Set{Tuple{Int, Int}}()
    for (tile, neighbor_count) in neighbor_counts
        if 3 <= neighbor_count <= 5
            push!(new_tiles, tile)
        end
    end
    return new_tiles
end
