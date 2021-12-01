function part1(input)
    depths = parse.(Int, readlines(input))
    return count(>(0), diff(depths))
end

function part2(input)
    depths = parse.(Int, readlines(input))
    filtered_depths = depths[1:(end - 2)] + depths[2:(end - 1)] + depths[3:end]
    return count(>(0), diff(filtered_depths))
end
