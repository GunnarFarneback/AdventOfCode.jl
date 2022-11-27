function part1(input)
    data = [parse.(Int, split(line, "\t")) for line in readlines(input)]
    return only(diff([reduce((x, y) -> x .+ y, extrema.(data), init = (0, 0))...]))
end

function part2(input)
    data = [parse.(Int, split(line, "\t")) for line in readlines(input)]
    return sum(process_row.(data))
end

function process_row(row)
    x = sort(row)
    for i = length(x):-1:2
        for j = 1:(i - 1)
            if mod(x[i], x[j]) == 0
                return x[i] ÷ x[j]
            end
        end
    end
    @assert false
end
