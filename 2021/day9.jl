using Multibreak

function part1(input)
    heights = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    risk = 0
    neighbors = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    C = CartesianIndices(heights)
    @multibreak for I in C
        for Δ in neighbors
            if I + Δ in C && heights[I + Δ] <= heights[I]
                break; continue
            end
        end
        risk += 1 + heights[I]
    end
    return risk
end

function part2(input)
    heights = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    mark = heights .== 9
    basin_sizes = Int[]
    neighbors = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    C = CartesianIndices(heights)
    queue = CartesianIndex[]
    for I in C
        if !mark[I]
            basin_size = 1
            push!(queue, I)
            mark[I] = true
            while !isempty(queue)
                x = pop!(queue)
                for Δ in neighbors
                    if x + Δ in C && !mark[x + Δ]
                        push!(queue, x + Δ)
                        basin_size += 1
                        mark[x + Δ] = true
                    end
                end
            end
            push!(basin_sizes, basin_size)
        end
    end
    return prod(sort(basin_sizes, rev = true)[1:3])
end
