struct Blizzard
    x::Int
    y::Int
    vx::Int
    vy::Int
end

function part1(input)
    blizzards = Blizzard[]
    for (y, line) in enumerate(eachline(input))
        parse_line!(blizzards, line, y)
    end
    W = maximum(blizzard.x for blizzard in blizzards) - 2
    H = maximum(blizzard.y for blizzard in blizzards) - 2
    start = (2, 1)
    goal = (W + 1, H + 2)
    positions = Set((start,))
    iteration = 0
    while true
        iteration += 1
        goal .- (0, 1) in positions && return iteration
        next_positions = empty(positions)
        for pos in positions
            push!(next_positions, pos)
            for delta in ((-1, 0), (1, 0), (0, 1), (0, -1))
                push!(next_positions, pos .+ delta)
            end
        end
        pop!(next_positions, start .- (0, 1))
        for b in blizzards
            if (b.vx, b.vy) != (0, 0)
                bpos = 2 .+ mod.((b.x - 2, b.y - 2) .+ iteration .* (b.vx, b.vy), (W, H))
            else
                bpos = (b.x, b.y)
            end
            bpos in next_positions && pop!(next_positions, bpos)
        end
        positions = next_positions
    end
end

function part2(input)
    blizzards = Blizzard[]
    for (y, line) in enumerate(eachline(input))
        parse_line!(blizzards, line, y)
    end
    W = maximum(blizzard.x for blizzard in blizzards) - 2
    H = maximum(blizzard.y for blizzard in blizzards) - 2
    start = (2, 1)
    goal = (W + 1, H + 2)
    state = 1
    positions = Set((start,))
    iteration = 0
    while true
        iteration += 1
        if goal in positions
            state == 3 && return iteration - 1
            positions = Set((goal,))
            if state == 1
                goal = start
            elseif state == 2
                goal = (W + 1, H + 2)
            end
            state += 1
        end
        next_positions = empty(positions)
        for pos in positions
            push!(next_positions, pos)
            for delta in ((-1, 0), (1, 0), (0, 1), (0, -1))
                push!(next_positions, pos .+ delta)
            end
        end
        if (start .- (0, 1)) in next_positions
            pop!(next_positions, start .- (0, 1))
        end
        if (W + 1, H + 3) in next_positions
            pop!(next_positions, (W + 1, H + 3))
        end
        for b in blizzards
            if (b.vx, b.vy) != (0, 0)
                bpos = 2 .+ mod.((b.x - 2, b.y - 2) .+ iteration .* (b.vx, b.vy), (W, H))
            else
                bpos = (b.x, b.y)
            end
            bpos in next_positions && pop!(next_positions, bpos)
        end
        positions = next_positions
    end

end

function parse_line!(blizzards, line, y)
    directions = Dict('#' => (0, 0),
                      '>' => (1, 0),
                      '<' => (-1, 0),
                      '^' => (0, -1),
                      'v' => (0, 1))
    for (x, c) in enumerate(line)
        if haskey(directions, c)
            push!(blizzards, Blizzard(x, y, directions[c]...))
        end
    end
end
