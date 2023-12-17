part1(input) = total_distance(input, 2)
part2(input) = total_distance(input, 1000000)

function total_distance(input, expansion)
    x = fill(0, 140)
    y = fill(0, 140)
    i = j = 1
    for c in input.data
        if c == UInt8('#')
            x[i] += 1
            y[j] += 1
        elseif c == UInt8('\n')
            i = 0
            j += 1
        end
        i += 1
    end
    return sum_distance(x, expansion) + sum_distance(y, expansion)
end

function sum_distance(x, expansion)
    a = b = c = 0
    for i in eachindex(x)
        b += a * (x[i] > 0 ? 1 : expansion)
        c += b * x[i]
        a += x[i]
    end
    return c
end
