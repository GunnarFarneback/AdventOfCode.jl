part1(input) = trace_knots(input, 2)
part2(input) = trace_knots(input, 10)

function trace_knots(input, n)
    dirs = Dict('L' => (-1, 0), 'R' => (1, 0), 'D' => (0, -1), 'U' => (0, 1))
    knots = fill((0, 0), n)
    tails = Set((knots[end],))
    for line in eachline(input)
        dir = dirs[line[1]]
        for i = 1:parse(Int, line[3:end])
            knots[1] = knots[1] .+ dir
            for i = 2:n
                knots[i] = update_tail(knots[i - 1], knots[i])
            end
            push!(tails, knots[end])
        end
    end
    return length(tails)
end

function update_tail(head, tail)
    delta = head .- tail
    any(>(1), abs.(delta)) &&  return tail .+ clamp.(delta, -1, 1)
    return tail
end
