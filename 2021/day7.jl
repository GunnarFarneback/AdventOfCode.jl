function part1(input)
    x = sort(parse.(Int, split(readchomp(input), ",")))
    return sum(abs.(x .- x[(end + 1) ÷ 2]))
end

part2_cost(n) = abs(n) * (abs(n) + 1) / 2
part2_total_cost(x, target) = sum(part2_cost(xi - target) for xi in x)

function part2(input)
    x = parse.(Int, split(readchomp(input), ","))
    target = sum(x) / length(x)
    return Int(minimum(part2_total_cost.(Ref(x), floor(target):ceil(target))))
end
