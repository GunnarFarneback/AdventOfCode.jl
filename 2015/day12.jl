using JSON

function part1(input)
    data = JSON.parse(readchomp(input))
    return sum_numbers(data)
end

function part2(input)
    data = JSON.parse(readchomp(input))
    return sum_numbers2(data)
end

sum_numbers(data::Dict) = sum(sum_numbers.(values(data)))
sum_numbers(data::Vector) = sum(sum_numbers.(data))
sum_numbers(data::Number) = data
sum_numbers(data::AbstractString) = 0

function sum_numbers2(data::Dict)
    if any(==("red"), values(data))
        return 0
    end
    return sum(sum_numbers2.(values(data)))
end
sum_numbers2(data::Vector) = sum(sum_numbers2.(data))
sum_numbers2(data::Number) = data
sum_numbers2(data::AbstractString) = 0
