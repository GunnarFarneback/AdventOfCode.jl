function part1(input)
    joltages = sort(parse.(Int, readlines(input)))
    num_one_diffs = count(==(1), diff(vcat(0, joltages)))
    num_three_diffs = count(==(3), diff(vcat(0, joltages))) + 1
    return num_one_diffs * num_three_diffs
end

function part2(input)
    joltages = sort(parse.(Int, readlines(input)))
    num_combinations = Dict{Int, Int}()
    num_combinations[0] = 1
    for joltage in joltages
        num_combinations[joltage] = sum(get(num_combinations, joltage - n, 0)
                                        for n in 1:3)
    end
    return num_combinations[last(joltages)]
end
