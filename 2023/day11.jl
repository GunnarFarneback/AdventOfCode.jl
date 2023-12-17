part1(input) = total_distance(input, 2)
part2(input) = total_distance(input, 1000000)

function total_distance(input, expansion_factor)
    coords = [[c[1], c[2]] for c in findall(==('#'), stack(eachline(input)))]
    expand!(coords, 1, expansion_factor)
    expand!(coords, 2, expansion_factor)
    s = 0
    for i in 1:length(coords)
        for j in (i + 1):length(coords)
            s += sum(abs.(coords[i] .- coords[j]))
        end
    end
    return s
end

function expand!(coords, k, expansion_factor)
    c = getindex.(coords, k)
    a, b = extrema(c)
    j = 0
    d = Dict{Int, Int}()
    for i in a:b
        if i ∉ c
            j += 1
        else
            d[i] = i + j * (expansion_factor - 1)
        end
    end
    for i in eachindex(coords)
        coords[i][k] = d[coords[i][k]]
    end
end
