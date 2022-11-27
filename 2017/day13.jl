function part1(input)
    data = read_input(input)
    return sum(compute_cost(data, 0))
end

function part2(input)
    data = read_input(input)
    delay = 0
    while true
        length(compute_cost(data, delay)) == 0 && return delay
        delay += 1
    end
end

function read_input(input)
    return Dict(parse(Int, x[1]) => parse(Int, x[2])
                for x in split.(eachline(input), ": "))
end

function compute_cost(data, delay)
    return [k * v for (k, v) in data if mod(delay + k, 2 * v - 2) == 0]
end
