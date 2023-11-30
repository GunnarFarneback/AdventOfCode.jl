directions = CartesianIndex.(((0, 1), (1, 0), (0, -1), (-1, 0)))

function part1(input)
    m, d = parse_input(input)
    x = findfirst(==('.'), m[1, :])
    pos = CartesianIndex(1, x)
    dir = 1
    for instruction in d
        pos, dir = move(m, pos, dir, instruction)
    end
    return 1000 * pos[1] + 4 * pos[2] + dir - 1
end

function part2(input)
    m, d = parse_input(input)
    x = findfirst(==('.'), m[1, :])
    pos = CartesianIndex(1, x)
    dir = 1
    for instruction in d
        pos, dir = move2(m, pos, dir, instruction)
    end
    return 1000 * pos[1] + 4 * pos[2] + dir - 1
end

function move(m, pos, dir, instruction::String)
    if instruction == "R"
        return pos, mod1(dir + 1, 4)
    else
        return pos, mod1(dir - 1, 4)
    end
end

move2(m, pos, dir, instruction::String) = move(m, pos, dir, instruction)

function move(m, pos, dir, instruction::Int)
    delta = directions[dir]
    for _ in 1:instruction
        new_pos = pos
        while true
            new_pos = CartesianIndex(mod1.(Tuple(new_pos + delta), size(m)))
            if m[new_pos] == '#'
                return pos, dir
            elseif m[new_pos] == '.'
                pos = new_pos
                break
            end
        end
    end
    return pos, dir
end

function move2(m, pos, dir, instruction::Int)
    for _ in 1:instruction
        old_pos, old_dir = pos, dir
        delta = directions[dir]
        pos, dir = wrap(pos + delta, dir)
        if m[pos] == '#'
            return old_pos, old_dir
        end
    end
    return pos, dir
end

function wrap(pos, dir)
    y = pos[1]
    x = pos[2]
    if x == 151 && 1 <= y <= 50 && dir == 1
        dir = 3
        y = 151 - y
        x = 100
    elseif x == 101 && 51 <= y <= 100 && dir == 1
        dir = 4
        x = y + 50
        y = 50
    elseif x == 101 && 101 <= y <= 150 && dir == 1
        dir = 3
        y = 151 - y
        x = 150
    elseif x == 51 && 151 <= y <= 200 && dir == 1
        dir = 4
        x = y - 100
        y = 150
    elseif x == 0 && 151 <= y <= 200 && dir == 3
        dir = 2
        x = y - 100
        y = 1
    elseif x == 0 && 101 <= y <= 150 && dir == 3
        dir = 1
        y = 151 - y
        x = 51
    elseif x == 50 && 51 <= y <= 100 && dir == 3
        dir = 2
        x = y - 50
        y = 101
    elseif x == 50 && 1 <= y <= 50 && dir == 3
        dir = 1
        y = 151 - y
        x = 1
    elseif 1 <= x <= 50 && y == 100 && dir == 4
        dir = 1
        y = x + 50
        x = 51
    elseif 51 <= x <= 100 && y == 0 && dir == 4
        dir = 1
        y = x + 100
        x = 1
    elseif 101 <= x <= 150 && y == 0 && dir == 4
        dir = 4
        x = x - 100
        y = 200
    elseif 101 <= x <= 150 && y == 51 && dir == 2
        dir = 3
        y = x - 50
        x = 100
    elseif 51 <= x <= 100 && y == 151 && dir == 2
        dir = 3
        y = x + 100
        x = 50
    elseif 1 <= x <= 50 && y == 201 && dir == 2
        dir = 2
        x = x + 100
        y = 1
    end
    return CartesianIndex(y, x), dir
end

function parse_input(input)
    m, d = split(readchomp(input), "\n\n")
    rows = collect.(split(m, "\n"))
    w = maximum(length.(rows))
    rows = pad_row.(rows, w)
    return permutedims(reduce(hcat, rows)), parse_directions(d)
end

function pad_row(row, w)
    return vcat(row, fill(' ', w - length(row)))
end

function parse_directions(d)
    directions = Union{Int, String}[]
    value = 0
    for c in d
        if isdigit(c)
            value = 10 * value + c - '0'
        else
            if value != 0
                push!(directions, value)
            end
            value = 0
            push!(directions, string(c))
        end
    end
    if value != 0
        push!(directions, value)
    end
    return directions
end
