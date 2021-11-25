function part1(input)
    seats = reduce(hcat, (line -> split(line, "") .== "L").(readlines(input)))
    occupied = falses(size(seats))
    while true
        neighbors = count_neighbors(occupied)
        next_occupied = ((neighbors .== 0) .|
                         ((neighbors .< 4) .& occupied)) .&
                         seats
        occupied == next_occupied && return count(occupied)
        occupied = next_occupied
    end
end

function part2(input)
    seats = reduce(hcat, (line -> split(line, "") .== "L").(readlines(input)))
    occupied = falses(size(seats))
    while true
        neighbors = count_visible(occupied, seats)
        next_occupied = ((neighbors .== 0) .|
                         ((neighbors .< 5) .& occupied)) .&
                         seats
        occupied == next_occupied && return count(occupied)
        occupied = next_occupied
    end
end

function count_neighbors(occupied)
    neighbors = zeros(Int, size(occupied))
    indices = CartesianIndices(occupied)
    for index in indices
        for Δ in CartesianIndices((-1:1, -1:1))
            Δ == CartesianIndex(0, 0) && continue
            if index + Δ in indices
                neighbors[index] += occupied[index + Δ]
            end
        end
    end
    return neighbors
end

function count_visible(occupied, seats)
    visible = zeros(Int, size(occupied))
    indices = CartesianIndices(occupied)
    for index in indices
        seats[index] || continue
        for Δ in CartesianIndices((-1:1, -1:1))
            Δ == CartesianIndex(0, 0) && continue
            current_index = index + Δ
            while current_index in indices
                if seats[current_index]
                    visible[index] += occupied[current_index]
                    break
                end
                current_index += Δ
            end
        end
    end
    return visible
end
