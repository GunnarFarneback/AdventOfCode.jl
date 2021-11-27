function part1(input)
    state = parse_input(input, 3)
    for i = 1:6
        state = simulate_cycle(state)
    end
    return length(state)
end

function part2(input)
    state = parse_input(input, 4)
    for i = 1:6
        state = simulate_cycle(state)
    end
    return length(state)
end

function parse_input(input, dims)
    state = Set{CartesianIndex{dims}}()
    for (i, line) in enumerate(readlines(input))
        for (j, c) in enumerate(split(line, ""))
            if c == "#"
                push!(state, CartesianIndex(i, j, fill(0, dims - 2)...))
            end
        end
    end
    return state
end

function simulate_cycle(state::Set{CartesianIndex{N}}) where N
    neighbors = Dict{CartesianIndex{N}, Int}()
    neighborhood = CartesianIndices(ntuple(i -> -1:1, N))
    for position in state
        for Δ in neighborhood
            if Δ == zero(CartesianIndex{N})
                neighbors[position + Δ] = get(neighbors, position + Δ, 0) + 1
            else
                neighbors[position + Δ] = get(neighbors, position + Δ, 0) + 2
            end
        end
    end
    return Set(position
               for (position, num_neighbors) in neighbors
               if 5 <= num_neighbors <= 7)
end
