function part1(input)
    return decompressed_length(readchomp(input), false)
end

function part2(input)
    return decompressed_length(readchomp(input), true)
end

function decompressed_length(data, recursive)
    output_length = 0
    i = 1
    while i <= length(data)
        if data[i] != '('
            output_length += 1
            i += 1
        else
            j = i + 1
            while data[j] != ')'
                j += 1
            end
            m, n = parse.(Int, split(data[(i + 1):(j - 1)], "x"))
            if recursive
                output_length += n * decompressed_length(data[(j + 1):(j + m)], true)
            else
                output_length += m * n
            end
            i = j + m + 1
        end
    end
    return output_length
end
