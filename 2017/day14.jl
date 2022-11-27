include("day10.jl")

function part1(input)
    key = readchomp(input)
    num_occupied = 0
    for i = 0:127
        hash = compute_knot_hash("$(key)-$i")
        num_occupied += sum(count_ones.(hash))
    end
    return num_occupied
end

function part2(input)
    key = readchomp(input)
    num_merges = 0
    id = fill(0, 128)
    last_id = 0
    for i in 0:127
        row = compute_knot_hash("$(key)-$i")
        for j = 0:127
            bit = row[1 + (j >> 3)] & (1 << (7 - (j & 7)))
            if bit != 0
                if id[1 + j] == 0
                    if j > 0 && id[j] > 0
                        id[1 + j] = id[j]
                    else
                        last_id += 1
                        id[1 + j] = last_id
                    end
                else
                    if j > 0 && 0 < id[j] != id[1 + j]
                        renumber_from = id[1 + j]
                        renumber_to = id[j]
                        for k in 1:128
                            if id[k] == renumber_from
                                id[k] = renumber_to
                            end
                        end
                        num_merges += 1
                    end
                end
            else
                id[1 + j] = 0
            end
        end
    end

    return last_id - num_merges
end
