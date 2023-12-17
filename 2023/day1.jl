function part1(input)
    return sum(parse(Int, filter(isdigit, line)[[1, end]])
               for line in eachline(input))
end

const digits = ("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
const rdigits = reverse.(digits)

function first_value(line, digits)
    parse(Int, first(filter(isdigit, replace(line, (digit => string(i) for (i, digit) in enumerate(digits))...))))
end

function part2(input)
    sum(10 * first_value(line, digits) + first_value(reverse(line), rdigits)
        for line in eachline(input))
end
