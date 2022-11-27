function part1(input)
    configuration, rules = parse_input(input)
    return simulate!(configuration, rules, part = 1)
end

function part2(input)
    configuration, rules = parse_input(input)
    simulate!(configuration, rules, part = 2)
    return prod(only(configuration[i]) for i in -3:-1)
end

function simulate!(configuration, rules; part)
    queue = [bot for (bot, values) in configuration if length(values) > 1]
    while !isempty(queue)
        bot = pop!(queue)
        values = sort(configuration[bot])
        part == 1 && values == [17, 61] && return bot
        delete!(configuration, bot)
        for i = 1:2
            receiver = rules[bot][i]
            push!(get!(configuration, receiver, Int[]), values[i])
            if receiver >= 0 && length(configuration[receiver]) > 1
                push!(queue, receiver)
            end
        end
    end
    part == 1 && @assert false
    return
end

function parse_input(input)
    configuration = Dict{Int, Vector{Int}}()
    rules = Dict{Int, Tuple{Int, Int}}()
    for line in eachline(input)
        words = split(line, " ")
        if startswith(line, "value")
            value, bot = parse.(Int, words[[2, 6]])
            push!(get!(configuration, bot, Int[]), value)
        else
            from, to1, to2 = parse.(Int, words[[2, 7, 12]])
            if words[6] == "output"
                to1 = -(to1 + 1)
            end
            if words[11] == "output"
                to2 = -(to2 + 1)
            end
            rules[from] = (to1, to2)
        end
    end
    return configuration, rules
end
