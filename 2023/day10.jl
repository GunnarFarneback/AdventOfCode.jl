function part1(input)
    m = permutedims(stack(collect.(eachline(input))))
    s = only(findall(==('S'), m))
    dirs = CartesianIndex.(((1, 0), (0, 1), (-1, 0), (0, -1)))
    loop = falses(size(m))
    return maximum(findloop.(Ref(m), Ref(s), dirs, Ref(loop))) .÷ 2
end

function part2(input)
    m = permutedims(stack(collect.(eachline(input))))
    s = only(findall(==('S'), m))
    dirs = CartesianIndex.(((1, 0), (0, 1), (-1, 0), (0, -1)))
    loop = falses(size(m))
    lengths = findloop.(Ref(m), Ref(s), dirs, Ref(loop))
    connections = lengths .== maximum(lengths)
    if connections == (true, false, true, false)
        m[s] = '|'
    elseif connections == (false, true, false, true)
        m[s] = '-'
    elseif connections == (true, true, false, false)
        m[s] = 'F'
    elseif connections == (true, false, false, true)
        m[s] = '7'
    elseif connections == (false, true, true, false)
        m[s] = 'L'
    elseif connections == (false, false, true, true)
        m[s] = 'J'
    else
        @assert false
    end
        
    n = 0
    parity = 0.0
    for i in axes(loop, 1)
        for j in axes(loop, 2)
            if loop[i, j]
                if m[i, j] == '|'
                    parity += 1
                elseif m[i, j] in "JF"
                    parity += 0.5
                elseif m[i, j] in "7L"
                    parity -= 0.5
                end
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
        p == CartesianIndex(0, 0) && return 0
        p == s && return n
    end
end
            
function move(m, p, d)
    p += d
    p in CartesianIndices(m) || return CartesianIndex(0, 0), CartesianIndex(0, 0)
    c = m[p]
    c == '.' && return CartesianIndex(0, 0), CartesianIndex(0, 0)
    c == 'S' && return p, d
    if d == CartesianIndex(1, 0)
        c in "-F7" && return CartesianIndex(0, 0), CartesianIndex(0, 0)
        c == '|' && return p, d
        c == 'L' && return p, CartesianIndex(0, 1)
        c == 'J' && return p, CartesianIndex(0, -1)
    elseif d == CartesianIndex(-1, 0)
        c in "-LJ" && return CartesianIndex(0, 0), CartesianIndex(0, 0)
        c == '|' && return p, d
        c == 'F' && return p, CartesianIndex(0, 1)
        c == '7' && return p, CartesianIndex(0, -1)
    elseif d == CartesianIndex(0, 1)
        c in "|LF" && return CartesianIndex(0, 0), CartesianIndex(0, 0)
        c == '-' && return p, d
        c == '7' && return p, CartesianIndex(1, 0)
        c == 'J' && return p, CartesianIndex(-1, 0)
    elseif d == CartesianIndex(0, -1)
        c in "|7J" && return CartesianIndex(0, 0), CartesianIndex(0, 0)
        c == '-' && return p, d
        c == 'F' && return p, CartesianIndex(1, 0)
        c == 'L' && return p, CartesianIndex(-1, 0)
    else
        @assert false
    end
end
