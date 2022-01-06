function part1(input)
    row, column = parse.(Int, match(r"(\d+)[^\d]+(\d+)", readchomp(input)).captures)
    entry = (row + column) * (row + column - 1) ÷ 2 - row + 1
    code = 20151125
    for i = 2:entry
        code = mod(code * 252533, 33554393)
    end
    return code
end

part2(input) = nothing
