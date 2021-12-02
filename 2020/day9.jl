function part1(input, preamble_length_str = "25")
    preamble_length = parse(Int, preamble_length_str)
    numbers = parse.(Int, readlines(input))
    return find_invalid(numbers, preamble_length)
end

function part2(input, preamble_length_str = "25")
    preamble_length = parse(Int, preamble_length_str)
    numbers = parse.(Int, readlines(input))
    invalid = find_invalid(numbers, preamble_length)
    for i = 1:length(numbers)
        partial_sum = numbers[i]
        j = i + 1
        while j <= length(numbers)
            partial_sum += numbers[j]
            if partial_sum == invalid
                return sum(extrema(numbers[i:j]))
            elseif partial_sum > invalid
                break
            end
            j += 1
        end
    end
end

function find_invalid(numbers, preamble_length)
    for i = (preamble_length + 1):length(numbers)
        if !is_sum_of_two(numbers[i], numbers[(i - preamble_length):(i - 1)])
            return numbers[i]
        end
    end
    @assert false
end

function is_sum_of_two(n, v)
    for i = 1:length(v)
        for j = (i + 1):length(v)
            v[i] + v[j] == n && return true
        end
    end
    return false
end
