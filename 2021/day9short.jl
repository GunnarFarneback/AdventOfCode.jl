using Images: mapwindow, Fill, label_components
using StatsBase: counts

function part1(input)
    heights = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    return mapwindow(heights, (3, 3), border = Fill(9)) do x
        x[2,2] < min(x[1,2], x[3,2], x[2,1], x[2,3]) ? 1 + x[2,2] : 0
    end |> sum
end

function part2(input)
    heights = reduce(hcat, (parse.(Int, split(line, "")) for line in eachline(input)))
    return prod(sort(counts(label_components(heights .< 9))[2:end], rev=true)[1:3])
end
