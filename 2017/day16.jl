function part1(input)
    order, names = dance(input)
    return join(names[order .- 'a' .+ 1], "")
end

function part2(input)
    order, names = dance(input)
    M1 = fill(0, 16, 16)
    M2 = fill(0, 16, 16)
    for i = 1:16
        j = order[i] - 'a' + 1
        M1[i, j] = 1
        j = names[i] - 'a' + 1
        M2[i, j] = 1
    end
    N = 10^9
    return String(UInt8.(M1^N * M2^N * UInt8.('a':'p')))
end

function dance(input)
    order = collect('a':'p')
    names = collect('a':'p')
    for instruction in split(readchomp(input), ",")
        if instruction[1] == 's'
            n = parse(Int, instruction[2:end])
            order = vcat(order[(end - n + 1):end], order[1:(end - n)])
        elseif instruction[1] == 'x'
            i, j = 1 .+ parse.(Int, split(instruction[2:end], "/"))
            order[i], order[j] = order[j], order[i]
        elseif instruction[1] == 'p'
            a = instruction[2]
            b = instruction[4]
            i = findfirst(==(a), names)
            j = findfirst(==(b), names)
            names[i], names[j] = names[j], names[i]
        end
    end
    return order, names
end
