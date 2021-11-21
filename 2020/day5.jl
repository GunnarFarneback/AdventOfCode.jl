function part1(input)
    return maximum(decode.(readlines(input)))
end

function part2(input)
    seats = decode.(readlines(input))
    return only(setdiff(minimum(seats):maximum(seats), seats))
end

function decode(s)
    for pair in ["B" => "1", "R" => "1", "F" => "0", "L" => "0"]
        s = replace(s, pair)
    end
    return parse(Int, s, base = 2)
end
