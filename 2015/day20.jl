function part1(input)
    n = parse(Int, readchomp(input))
    houses = zeros(Int, n)
    for i = 1:n
        houses[i:i:end] .+= 10 * i
    end
    return findfirst(>=(n), houses)
end

function part2(input)
    n = parse(Int, readchomp(input))
    houses = zeros(Int, n)
    for i = 1:n
        houses[i:i:min(end, (50 * i))] .+= 11 * i
    end
    return findfirst(>=(n), houses)
end
