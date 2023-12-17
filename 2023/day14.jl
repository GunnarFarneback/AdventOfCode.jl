function part1(input)
    m = permutedims(stack(eachline(input)))
    return north_load(m)
end

function part2(input)
    m = permutedims(stack(eachline(input)))
    states = Matrix{Char}[]
    loads = Int[]
    while true
        m = spin_cycle(m)
        push!(loads, load(m))
        if m in states
            i = findfirst(==(m), states)
            j = mod(length(loads) - 1000000000, length(loads) - i)
            return loads[end - j]
            break
        end
        push!(states, copy(m))
    end
    return north_load(m)
end

function spin_cycle(m)
    for i in 1:4
        roll_north!(m)
        m = rotr90(m)
    end
    return m
end

function roll_north!(m)
    for i in axes(m, 2)
        w = 1
        for j in axes(m, 1)
            if m[j, i] == '#'
                w = j + 1
            elseif m[j, i] == 'O'
                if w < j
                    m[j, i], m[w, i] = m[w, i], m[j, i]
                end
                w += 1
            end
        end
    end        
end

function north_load(m)
    W = 0
    for i in axes(m, 2)
        w = size(m, 1)
        for j in axes(m, 1)
            if m[j, i] == '#'
                w = size(m, 1) - j
            elseif m[j, i] == 'O'
                W += w
                w -= 1
            end
        end
    end
    return W
end    

function load(m)
    return sum(size(m, 1) - I[1] + 1 for I in CartesianIndices(m) if m[I] == 'O')
end
