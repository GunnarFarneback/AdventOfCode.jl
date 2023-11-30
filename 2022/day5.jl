function part1(input)
    state = 1
    stacks = [Char[] for _ in 1:9]
    for line in eachline(input)
        if state == 1
            if line[2] == '1'
                state = 2
            else
                for i = 1:9
                    c = line[4 * i - 2]
                    if c != ' '
                        pushfirst!(stacks[i], c)
                    end
                end
            end
        elseif state == 2
            state = 3
        else
            n, from, to = parse.(Int, split(line)[2:2:6])
            for i = 1:n
                push!(stacks[to], pop!(stacks[from]))
            end
        end
    end
    return join(last.(stacks))
end

function part2(input)
    state = 1
    stacks = [Char[] for _ in 1:9]
    temp = Char[]
    for line in eachline(input)
        if state == 1
            if line[2] == '1'
                state = 2
            else
                for i = 1:9
                    c = line[4 * i - 2]
                    if c != ' '
                        pushfirst!(stacks[i], c)
                    end
                end
            end
        elseif state == 2
            state = 3
        else
            n, from, to = parse.(Int, split(line)[2:2:6])
            for i = 1:n
                push!(temp, pop!(stacks[from]))
            end
            for i = 1:n
                push!(stacks[to], pop!(temp))
            end
        end
    end
    return join(last.(stacks))
end
