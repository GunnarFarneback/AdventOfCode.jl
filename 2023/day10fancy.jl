const south = 0b1000
const north = 0b0100
const east =  0b0010
const west =  0b0001
const empty = 0b0000
const start = 0b1111
const symbols = Dict('.' => empty, 'S' => start,
                     '|' => south | north, '-' => east | west,
                     'F' => south | east, 'L' => north | east,
                     '7' => south | west, 'J' => north | west)
const directions = Dict(south => CartesianIndex(1, 0),
                        north => CartesianIndex(-1, 0),
                        east => CartesianIndex(0, 1),
                        west => CartesianIndex(0, -1))
const reverse = Dict(south => north, north => south,
                     east => west, west => east)
const parities = Dict(north | south => 1.0,
                      north | west => 0.5,
                      south | east => 0.5,
                      south | west => -0.5,
                      north | east => -0.5)

function part1(input)
    m = getindex.(Ref(symbols), permutedims(stack(collect.(eachline(input)))))
    s = only(findall(==(start), m))
    dirs = (south, north, east, west)
    loop = falses(size(m))
    return maximum(findloop.(Ref(m), Ref(s), dirs, Ref(loop)) .÷ 2)
end

function part2(input)
    m = getindex.(Ref(symbols), permutedims(stack(collect.(eachline(input)))))
    s = only(findall(==(start), m))
    dirs = (south, north, east, west)
    loop = falses(size(m))
    lengths = findloop.(Ref(m), Ref(s), dirs, Ref(loop))
    m[s] = |(dirs[[(lengths .== maximum(lengths))...]]...)
    n = 0
    parity = 0.0
    for i in axes(loop, 1)
        for j in axes(loop, 2)
            if loop[i, j]
                parity += get(parities, m[i, j], 0.0)
            end
            n += (!loop[i, j] & (mod(parity, 2) == 1))
        end
    end
    return n
end

function findloop(m, s, d, loop)
    n = 0
    p = s
    while true
        loop[p] = true
        p, d = move(m, p, d)
        n += 1
        d == empty && return 0
        d == start && return n
    end
end
            
function move(m, p, d)
    p += directions[d]
    p in CartesianIndices(m) || return p, empty
    c = m[p]
    d = reverse[d]
    (c & d) == 0 && return p, empty
    c == start && return p, start
    return p, c ⊻ d
end
