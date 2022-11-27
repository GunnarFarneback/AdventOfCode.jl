function part1(input)
    data = split.(eachline(input), " ")
    return count(x -> length(x) == length(unique(x)), data)
end

function part2(input)
    data = split.(eachline(input), " ")
    data = map(line -> map(word -> sort(split(word, "")), line), data)
    return count(x -> length(x) == length(unique(x)), data)
end
