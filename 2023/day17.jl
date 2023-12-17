const south = CartesianIndex((1, 0))
const north = CartesianIndex((-1, 0))
const west = CartesianIndex((0, -1))
const east = CartesianIndex((0, 1))

function left(d)
    d == south && return east
    d == east && return north
    d == north && return west
    return south
end

function right(d)
    d == south && return west
    d == west && return north
    d == north && return east
    return south
end

struct State
    pos::CartesianIndex{2}
    dir::CartesianIndex{2}
    n::Int
end

part1(input) = search(input, 1)
part2(input) = search(input, 2)

function search(input, part)
    m = permutedims(stack(eachline(input))) .- '0'
    M = CartesianIndices(m)
    queue = Dict{Int, Vector{State}}(0 => [State(first(M), east, 0)])
    visited = Set{State}(queue[0])
    i = 0
    while true
        for (;pos, dir, n) in get(queue, i, State[])
            for f in (left, identity, right)
                part == 2 && f != identity && 0 < n < 4 && continue
                n′ = (f == identity) ? n + 1 : 1
                part == 1 && n′ > 3 && continue
                part == 2 && n′ > 10 && continue
                dir′ = f(dir)
                pos′ = pos + dir′
                pos′ in M || continue
                j = i + m[pos′]
                part == 1 && pos′ == last(M) && return j
                part == 2 && pos′ == last(M) && n′ >= 4 && return j
                state = State(pos′, dir′, n′)
                if state ∉ visited
                    push!(visited, state)
                    push!(get!(() -> State[], queue, j), state)
                end
            end
        end
        i += 1
    end
end
