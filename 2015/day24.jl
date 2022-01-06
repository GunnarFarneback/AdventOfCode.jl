function part1(input)
    weights = reverse(parse.(Int, eachline(input)))
    best = [length(weights) + 1, 0]
    find_best_partition(weights, best, sum(weights) ÷ 3)
    return last(best)
end

function part2(input)
    weights = reverse(parse.(Int, eachline(input)))
    best = [length(weights) + 1, 0]
    find_best_partition(weights, best, sum(weights) ÷ 4)
    return last(best)
end

function find_best_partition(weights, best, missing_weight, next = 1,
                             placed = zeros(Int, length(weights)))
    for i = next:length(weights)
        placed[i] != 0 && continue
        if weights[i] == missing_weight
            n = sum(placed) + 1
            qe = prod(weights[placed .== 1]) * weights[i]
            if [n, qe] < best
                best .= [n, qe]
            end
            return
        end
        weights[i] > missing_weight && continue
        weights[i] * (first(best) - sum(placed)) < missing_weight && continue
        placed[i] = 1
        find_best_partition(weights, best, missing_weight - weights[i],
                            i + 1, placed)
        placed[i] = 0
    end
end
