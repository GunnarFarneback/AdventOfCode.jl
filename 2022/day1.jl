function part1(input)
    return maximum(sum, parse_input(input))
end

function part2(input)
    return sum(sort(sum.(parse_input(input)), rev=true)[1:3])
end

function parse_input(input)
    x = [Int[]]
    for line in eachline(input)
        if isempty(line)
            push!(x, Int[])
        else
            push!(x[end], parse(Int, line))
        end
    end
    return x
end

function parse_input_compact_but_slow(input)
    (x -> parse.(Int, split(x, "\n"))).(split(readchomp(input), "\n\n"))
end
