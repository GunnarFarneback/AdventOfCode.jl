function part1(input)
    state = Int8[]
    risk = 0
    first_row = true
    i = 0
    while !eof(input)
        c = read(input, UInt8)
        if c == UInt8('\n')
            first_row = false
            i = 0
            continue
        end
        i += 1
        height = Int8(c - UInt8('0'))
        if first_row
            push!(state, height)
            if i > 1
                if abs(state[i - 1]) >= height
                    state[i - 1] = -abs(state[i - 1])
                elseif abs(state[i - 1]) <= height
                    state[i] = -height
                end
            end
        else
            if abs(state[i]) < height
                if state[i] >= 0
                    risk += 1 + state[i]
                end
                state[i] = -height
            elseif abs(state[i]) == height
                state[i] = -height
            else
                state[i] = height
            end

            if i > 1
                if abs(state[i - 1]) >= height
                    state[i - 1] = -abs(state[i - 1])
                elseif abs(state[i - 1]) <= height
                    state[i] = -height
                end
            end
        end
    end
    for height in state
        if height >= 0
            risk += 1 + height
        end
    end
    return risk
end

mutable struct State
    next::Int
    prev::Int
    size::Int
    ref::Int
end

function part2(input)
    state = State[]
    largest_basins = (0, 0, 0)
    first_row = true
    i = 0
    while !eof(input)
        c = read(input, UInt8)
        if c == UInt8('\n')
            first_row = false
            i = 0
            continue
        end
        i += 1
        height = c - UInt8('0')
        if first_row
            if height == 9
                push!(state, State(0, 0, 0, 0))
            else
                if i == 1 || state[i - 1].ref == 0
                    push!(state, State(i, i, 1, i))
                else
                    push!(state, State(state[i - 1].next, i - 1, 1, state[i - 1].ref))
                    state[i - 1].next = i
                    state[state[i].next].prev = i
                end
            end
        else
            if height == 9
                if state[i].next == i
                    largest_basins = update_largest_basins(largest_basins, state[i].size)
                elseif state[i].ref != 0
                    n = state[i].next
                    p = state[i].prev
                    state[n].prev = state[i].prev
                    state[p].next = state[i].next
                    state[n].size += state[i].size
                end
                state[i].next = 0
                state[i].prev = 0
                state[i].size = 0
                state[i].ref = 0
            else
                if state[i].ref != 0
                    state[i].size += 1
                else
                    state[i].next = i
                    state[i].prev = i
                    state[i].size = 1
                    state[i].ref = i
                end
                if i > 1 && state[i - 1].ref != 0
                    merge!(state, i - 1, i)
                end
            end
        end
    end
    for i = 1:length(state)
        if state[i].next == i
            largest_basins = update_largest_basins(largest_basins, state[i].size)
        elseif state[i].ref != 0
            n = state[i].next
            p = state[i].prev
            state[n].prev = state[i].prev
            state[p].next = state[i].next
            state[n].size += state[i].size
        end
    end
    return prod(largest_basins)
end

function merge!(state, i, j)
    state[i].ref == state[j].ref && return
    k = state[j].next
    while true
        state[k].ref = state[i].ref
        k == j && break
        k = state[k].next
    end
    in = state[i].next
    jn = state[j].next
    state[i].next = jn
    state[j].next = in
    state[in].prev = j
    state[jn].prev = i
end

function update_largest_basins(b, n)
    n > b[1] && return (n, b[1], b[2])
    n > b[2] && return (b[1], n, b[2])
    n > b[3] && return (b[1], b[2], n)
    return b
end
