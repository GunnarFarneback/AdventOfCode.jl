function part1(input)
    risk = reduce(hcat, (parse.(Int, collect(line))
                         for line in eachline(input)))
    return shortest_path(risk)
end

function part2(input)
    risk = reduce(hcat, (parse.(Int, collect(line))
                         for line in eachline(input)))
    h, w = size(risk)
    risk = repeat(risk, 5, 5)
    risk .+= div.(0:(size(risk, 1) - 1), h)
    risk .+= permutedims(div.(0:(size(risk, 2) - 1), w))
    risk .= mod1.(risk, 9)
    return shortest_path(risk)
end

function shortest_path(risk)
    queue = [CartesianIndex{2}[] for i = 1:10]
    push!(queue[10], CartesianIndex((1, 1)))
    neighbors = CartesianIndex.(((1, 0), (-1, 0), (0, 1), (0, -1)))
    total_risk = fill(typemax(Int), size(risk))
    C = CartesianIndices(risk)
    finish = last(C)
    v = 0
    while true
        while isempty(queue[mod1(v, 10)])
            v += 1
        end
        pos = pop!(queue[mod1(v, 10)])
        pos == finish && return v
        for neighbor in Ref(pos) .+ neighbors
            neighbor in C || continue
            neighbor_risk = v + risk[neighbor]
            neighbor_risk < total_risk[neighbor] || continue
            total_risk[neighbor] = neighbor_risk
            push!(queue[mod1(neighbor_risk, 10)], neighbor)
        end
    end
end
