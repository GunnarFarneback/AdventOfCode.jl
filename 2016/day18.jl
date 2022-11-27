function part1(input)
    first_row = collect(readchomp(input)) .== '.'
    return count_safe(first_row, 40)
end

function part2(input)
    first_row = collect(readchomp(input)) .== '.'
    return count_safe(first_row, 400000)
end

function count_safe(row, n)
    num_safe = count(row)
    for i = 2:n
        row = next_row(row)
        num_safe += count(row)
    end
    return num_safe
end

function next_row(row)
    next_row = copy(row)
    for i = 1:length(row)
        if i == 1
            next_row[i] = row[i + 1]
        elseif i == length(row)
            next_row[i] = row[i - 1]
        else
            next_row[i] = row[i - 1] == row[i + 1]
        end
    end
    return next_row
end
