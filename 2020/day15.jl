function part1(input)
    starting_numbers = parse.(Int, split(read(input, String), ","))
    return run_game(starting_numbers, 2020)
end

function part2(input)
    starting_numbers = parse.(Int, split(read(input, String), ","))
    return run_game(starting_numbers, 30000000)
end

function run_game(starting_numbers, iterations)
    last_spoken = Dict{Int, Int}()
    number = 0
    next_number = 0
    for i = 1:iterations
        if i <= length(starting_numbers)
            number = starting_numbers[i]
        else
            number = next_number
        end
        next_number = i - get(last_spoken, number, i)
        last_spoken[number] = i
    end
    return number
end
