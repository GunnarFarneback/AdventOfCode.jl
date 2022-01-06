function part1(input)
    x = collect(readchomp(input))
    return count(==('('), x) - count(==(')'), x)
end

function part2(input)
    x = collect(readchomp(input))
    level = 0
    for i = 1:length(x)
        level += x[i] == '(' ? 1 : -1
        level < 0 && return i
    end
end
