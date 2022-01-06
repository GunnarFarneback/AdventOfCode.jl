function part1(input)
    house = (0, 0)
    lucky_children = Set((house,))
    directions = Dict('^' => (0, -1), 'v' => (0, 1), '>' => (1, 0), '<' => (-1, 0))
    for c in collect(readchomp(input))
        house = house .+ directions[c]
        push!(lucky_children, house)
    end
    return length(lucky_children)
end

function part2(input)
    house = (0, 0)
    robo_house = (0, 0)
    lucky_children = Set((house,))
    directions = Dict('^' => (0, -1), 'v' => (0, 1), '>' => (1, 0), '<' => (-1, 0))
    for (i, c) in enumerate(collect(readchomp(input)))
        if i & 1 == 1
            house = house .+ directions[c]
            push!(lucky_children, house)
        else
            robo_house = robo_house .+ directions[c]
            push!(lucky_children, robo_house)
        end
    end
    return length(lucky_children)
end
