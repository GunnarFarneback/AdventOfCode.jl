const south = CartesianIndex((1, 0))
const north = CartesianIndex((-1, 0))
const west = CartesianIndex((0, -1))
const east = CartesianIndex((0, 1))

function part1(input)
    m = permutedims(stack(eachline(input)))
    return analyze(m, CartesianIndex(1, 1), east)
end

function part2(input)
    m = permutedims(stack(eachline(input)))
    results = []
    for i in axes(m, 1)
        push!(results, analyze(m, CartesianIndex(i, 1), east))
        push!(results, analyze(m, CartesianIndex(i, size(m, 2)), west))
    end
    for j in axes(m, 2)
        push!(results, analyze(m, CartesianIndex(1, j), south))
        push!(results, analyze(m, CartesianIndex(size(m, 1), j), north))
    end
    return maximum(results)
end

function analyze(m, I, d)
    M = CartesianIndices(m)
    queue = [(I, d)]
    visited = Set(queue)
    energized = Set((I,))
    while !isempty(queue)
        (I, d) = popfirst!(queue)
        if m[I] == '.'
            move!(M, queue, visited, energized, I, d)
        elseif m[I] == '/'
            d = Dict(east => north, south => west, west => south, north => east)[d]
            move!(M, queue, visited, energized, I, d)
        elseif m[I] == '\\'
            d = Dict(east => south, south => east, west => north, north => west)[d]
            move!(M, queue, visited, energized, I, d)
        elseif m[I] == '-'
            if d in (east, west)
                move!(M, queue, visited, energized, I, d)
            else
                move!(M, queue, visited, energized, I, west)
                move!(M, queue, visited, energized, I, east)
            end
        elseif m[I] == '|'
            if d in (north, south)
                move!(M, queue, visited, energized, I, d)
            else
                move!(M, queue, visited, energized, I, south)
                move!(M, queue, visited, energized, I, north)
            end
        else
            @assert false
        end
    end
    return length(energized)    
end

function move!(M, queue, visited, energized, I, d)
    I += d
    if I ∉ M
        return
    end
    (I, d) in visited && return
    push!(visited, (I, d))
    push!(energized, I)
    push!(queue, (I, d))
end
