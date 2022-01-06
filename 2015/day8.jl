function part1(input)
    return sum(overhead1.(eachline(input)))
end

function part2(input)
    return sum(overhead2.(eachline(input)))
end

function overhead1(line)
    i = 2
    overhead = 2
    while i < length(line)
        if line[i] == '\\'
            if line[i + 1] == 'x'
                i += 4
                overhead += 3
            else
                i += 2
                overhead += 1
            end
        else
            i += 1
        end
    end
    return overhead
end

function overhead2(line)
    overhead = 2
    for c in line
        overhead += c in "\\\""
    end
    return overhead
end
