function part1(input)
    return first(route(input))
end

function part2(input)
    return last(route(input))
end

function route(input)
    diagram = permutedims(reduce(hcat, collect.(readlines(input))))
    letters = Char[]
    num_steps = 0
    pos = (1, findfirst(!isspace, diagram[1, :]))
    dir = (1, 0)
    while true
        num_steps += 1
        pos = pos .+ dir
        c = diagram[pos...]
        if isletter(c)
            push!(letters, c)
        elseif c == '+'
            dir = reverse(dir)
            @assert isspace(diagram[(pos .+ dir)...]) || isspace(diagram[(pos .- dir)...])
            if isspace(diagram[(pos .+ dir)...])
                dir = .-(dir)
            end
        elseif isspace(c)
            break
        end
    end
    return join(letters), num_steps
end
