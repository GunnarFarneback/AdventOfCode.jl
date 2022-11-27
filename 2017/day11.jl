function part1(input)
    directions = Dict("n" =>  [1, 0, 0],
                      "ne" => [0, -1, 0],
                      "se" => [0, 0, 1],
                      "s" =>  [-1, 0, 0],
                      "sw" => [0, 1, 0],
                      "nw" => [0, 0, -1])
    position = [0, 0, 0]
    for move in split(readchomp(input), ",")
        position .+= directions[move]
    end
    return maximum(position) - minimum(position)
end

function part2(input)
    directions = Dict("n" =>  [1, 0, 0],
                      "ne" => [0, -1, 0],
                      "se" => [0, 0, 1],
                      "s" =>  [-1, 0, 0],
                      "sw" => [0, 1, 0],
                      "nw" => [0, 0, -1])
    position = [0, 0, 0]
    max_distance = 0
    for move in split(readchomp(input), ",")
        position .+= directions[move]
        distance = maximum(position) - minimum(position)
        max_distance = max(max_distance, distance)
    end
    return max_distance
end
