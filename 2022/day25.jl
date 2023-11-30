function part1(input)
    s = 0
    for line in eachline(input)
        s += snafu(line)
    end
    return inverse_snafu(s)
end

function part2(input)
end

function snafu(line)
    t = 0
    for c in line
        t *= 5
        if c == '2'
            t += 2
        elseif c == '1'
            t += 1
        elseif c == '0'
            t += 0
        elseif c == '-'
            t -= 1
        elseif c == '='
            t -= 2
        end
    end
    return t
end

function inverse_snafu(x)
    snafu = Char[]
    while x > 0
        x, y = divrem(x, 5)
        if y >= 3
            x += 1
        end
        pushfirst!(snafu, ['0', '1', '2', '=', '-'][y + 1])
    end
    return join(snafu)
end
