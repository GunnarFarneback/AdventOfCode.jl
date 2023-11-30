west = CartesianIndex.(((0, -1), (1, -1), (-1, -1)))
east = CartesianIndex.(((0, 1), (1, 1), (-1, 1)))
south = CartesianIndex.(((1, 0), (1, -1), (1, 1)))
north = CartesianIndex.(((-1, 0), (-1, -1), (-1, 1)))
box = union(west, east, south, north)
search_directions = (north, south, west, east)

function part1(input)
    elves_map = permutedims(reduce(hcat, (collect(line) .== '#' for line in eachline(input))))
    elves = findall(elves_map)
    for i in 1:10
        s = Set(elves)
        c = Dict{CartesianIndex{2}, Int}()
        elves_next = copy(elves)
        for (k, elf) in enumerate(elves)
            candidate = elf + CartesianIndex(0, 0)
            for j = 0:3
                search = search_directions[mod1(i + j, 4)]
                if all((elf + delta) ∉ s for delta in search)
                    if j > 0 || any((elf + delta) in s for delta in box)
                        candidate = elf + search[1]
                    end
                    break
                end
            end
            elves_next[k] = candidate
            c[candidate] = get(c, candidate, 0) + 1
        end
        for k in eachindex(elves)
            if c[elves_next[k]] == 1
                elves[k] = elves_next[k]
            end
        end
    end
    a = extrema(e[1] for e in elves)
    b = extrema(e[2] for e in elves)
    return (a[2] - a[1] + 1) * (b[2] - b[1] + 1) - length(elves)
end

function part2(input)
    elves_map = permutedims(reduce(hcat, (collect(line) .== '#' for line in eachline(input))))
    elves = findall(elves_map)
    iteration = 0
    while true
        iteration += 1
        did_move = false
        s = Set(elves)
        c = Dict{CartesianIndex{2}, Int}()
        elves_next = copy(elves)
        for (k, elf) in enumerate(elves)
            candidate = elf + CartesianIndex(0, 0)
            for j = 0:3
                search = search_directions[mod1(iteration + j, 4)]
                if all((elf + delta) ∉ s for delta in search)
                    if j > 0 || any((elf + delta) in s for delta in box)
                        candidate = elf + search[1]
                    end
                    break
                end
            end
            elves_next[k] = candidate
            c[candidate] = get(c, candidate, 0) + 1
        end
        for k in eachindex(elves)
            if c[elves_next[k]] == 1
                if elves[k] != elves_next[k]
                    did_move = true
                    elves[k] = elves_next[k]
                end
            end
        end
        if !did_move
            break
        end
    end
    a = extrema(e[1] for e in elves)
    b = extrema(e[2] for e in elves)
    return iteration
end
