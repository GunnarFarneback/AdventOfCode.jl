function part1(input)
    blacklist = sort(parse_line.(eachline(input)))
    return filter_blacklist(blacklist, part = 1)
end

function part2(input)
    blacklist = sort(parse_line.(eachline(input)))
    return filter_blacklist(blacklist, part = 2)
end

parse_line(line) = parse.(Int, split(line, "-"))

function filter_blacklist(blacklist; part)
    start = 0
    allowed = 0
    for (a, b) in blacklist
        if a > start
            part == 1 && return start
            allowed += a - start
        end
        start = max(start, b + 1)
    end
    part == 1 && return start
    return allowed + 4294967296 - start
end
