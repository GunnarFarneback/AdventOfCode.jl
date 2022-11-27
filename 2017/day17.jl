function part1(input)
    step = parse.(Int, readchomp(input))
    buffer = [0]
    n = 1
    for i = 1:2017
        n = 1 + mod1(n + step, length(buffer))
        insert!(buffer, n, i)
    end
    return buffer[mod1(n + 1, length(buffer))]
end

function part2(input)
    step = parse.(Int, readchomp(input))
    N = 50000000
    m = -1
    n = 0
    for i = 1:N
        n = mod(n + step, i)
        if n == 0
            m = i
        end
        n += 1
    end
    return m
end
