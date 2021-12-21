function part1(input)
    numbers = eval.(Meta.parse.(readlines(input)))
    return magnitude(foldl(add, numbers))
end

function part2(input)
    numbers = eval.(Meta.parse.(readlines(input)))
    magnitudes = Int[]
    for i = 1:length(numbers)
        for j = 1:length(numbers)
            i == j && continue
            push!(magnitudes, magnitude(add(numbers[i], numbers[j])))
        end
    end
    return maximum(magnitudes)
end

function explode(number::Vector, depth = 0)
    if depth < 4
        a, done, left, right = explode(first(number), depth + 1)
        if done
            b = add_left(last(number), right)
            return [a, b], done, left, nothing
        end
        b, done, left, right = explode(last(number), depth + 1)
        if done
            a = add_right(first(number), left)
            return [a, b], done, nothing, right
        end
        return number, false, nothing, nothing
    end
    return 0, true, first(number), last(number)
end

explode(number::Int, depth) = number, false, nothing, nothing

function add_right(number::Vector, n::Int)
    return [first(number), add_right(last(number), n)]
end

function add_left(number::Vector, n::Int)
    return [add_left(first(number), n), last(number)]
end

add_right(number::Int, n::Int) = number + n
add_left(number::Int, n::Int) = number + n
add_right(number, ::Nothing) = number
add_left(number, ::Nothing) = number

function split(number::Vector)
    a, done = split(first(number))
    if done
        return [a, last(number)], done
    end
    b, done = split(last(number))
    return [a, b], done
end

function split(number::Int)
    if number > 9
        return [number ÷ 2, (number + 1) ÷ 2], true
    end
    return number, false
end

add(x, y) = reduce([x, y])

function reduce(x)
    while true
        x, done, _, _ = explode(x)
        done && continue
        x, done = split(x)
        done || break
    end
    return x
end

magnitude(number::Vector) = 3 * magnitude(first(number)) + 2 * magnitude(last(number))
magnitude(number::Int) = number
