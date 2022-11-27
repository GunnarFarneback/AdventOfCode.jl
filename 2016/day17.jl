using MD5: md5

function part1(input)
    passcode = readchomp(input)
    return find_path(passcode, part = 1)
end

function part2(input)
    passcode = readchomp(input)
    return length(find_path(passcode, part = 2))
end

function find_path(passcode; part)
    map_area = CartesianIndices((1:4, 1:4))
    queue = [("", CartesianIndex(1, 1))]
    longest_route = ""
    while !isempty(queue)
        moves, position = popfirst!(queue)
        hash = join(string.(md5(passcode * moves), base = 16, pad = 2))
        for (i, (letter, Δ)) in enumerate((("U", CartesianIndex(-1, 0)),
                                           ("D", CartesianIndex(1, 0)),
                                           ("L", CartesianIndex(0, -1)),
                                           ("R", CartesianIndex(0, 1))))
            hash[i] in "bcdef" || continue
            new_position = position + Δ
            new_position in map_area || continue
            new_moves = moves * letter
            if new_position == CartesianIndex(4, 4)
                part == 1 && return new_moves
                longest_route = new_moves
            else
                push!(queue, (new_moves, new_position))
            end
        end
    end
    @assert part == 2
    return longest_route
end
