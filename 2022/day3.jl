function part1(input)
    return sum(priority, (only(intersect(line[1:(end ÷ 2)],
                                         line[(end ÷ 2 + 1):end]))
                          for line in eachline(input)))
end

function part2(input)
    lines = readlines(input)
    return sum(priority, (only(intersect(lines[i], lines[i + 1], lines[i + 2]))
                          for i in 1:3:length(lines)))
end

priority(c) = (c > 'Z') ? c - 'a' + 1 : c - 'A' + 27
