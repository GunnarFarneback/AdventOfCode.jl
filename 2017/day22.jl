function part1(input)
    infected, pos, dir = parse_input(input)
    infecting_bursts = 0

    for i = 1:10000
        if pos in infected
            dir = (last(dir), -first(dir))
            pop!(infected, pos)
        else
            dir = (-last(dir), first(dir))
            push!(infected, pos)
            infecting_bursts += 1
        end
        pos = pos .+ dir
    end

    return infecting_bursts
end

function part2(input)
    infected, pos, dir = parse_input(input)
    state = Dict(pos => :infected for pos in infected)
    infecting_bursts = 0

    for i = 1:10000000
        current_state = get(state, pos, :clean)
        if current_state == :clean
            dir = (-last(dir), first(dir))
            state[pos] = :weakened
        elseif current_state == :weakened
            infecting_bursts += 1
            state[pos] = :infected
        elseif current_state == :infected
            dir = (last(dir), -first(dir))
            state[pos] = :flagged
        elseif current_state == :flagged
            dir = (-first(dir), -last(dir))
            state[pos] = :clean
        end
        pos = pos .+ dir
    end

    return infecting_bursts
end

function parse_input(input)
    infected = Set{Tuple{Int, Int}}()
    N = 0
    for (y, line) in enumerate(eachline(input))
        N = length(line)
        for (x, c) in enumerate(line)
            if c == '#'
                push!(infected, (x, -y))
            end
        end
    end
    pos = ((N + 1) ÷ 2, -(N + 1) ÷ 2)
    dir = (0, 1)

    return infected, pos, dir
end
