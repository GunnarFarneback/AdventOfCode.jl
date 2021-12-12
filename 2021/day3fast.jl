function part1(input)
    nothing
end

function part2(input)
    x = parse_input(input)

    mask = 1 << 11
    start, stop = 1, length(x)
    last0 = partialsort(x, mask, start, stop)
    if last0 - start > stop - last0 - 1
        start2, stop2 = last0 + 1, stop
        stop = last0
    else
        start2, stop2 = start, last0
        start = last0 + 1
    end

    while start < stop
        mask >>= 1
        last0 = partialsort(x, mask, start, stop)
        if last0 - start > stop - last0 - 1
            stop = last0
        else
            start = last0 + 1
        end
    end
    oxygen = x[start]

    start, stop = start2, stop2
    mask = 1 << 10
    while start < stop
        last0 = partialsort(x, mask, start, stop)
        if last0 - start > stop - last0 - 1
            start = last0 + 1
        else
            stop = last0
        end
        mask >>= 1
    end
    CO2 = x[start]

    return oxygen * CO2
end

function parse_input(input)
    x = Int[]
    sizehint!(x, 1000)
    n = 0
    for c in read(input)
        if c == UInt8('\n')
            push!(x, n)
            n = 0
        else
            n <<= 1
            n |= c == UInt8('1')
        end
    end
    return x
end

function partialsort(x, mask, start, stop)
    last0 = start - 1
    while start < stop
        while start < stop && (x[start] & mask) == 0
            last0 = start
            start += 1
        end
        while start < stop && (x[stop] & mask) != 0
            stop -= 1
        end
        if start < stop
            x[start], x[stop] =  x[stop], x[start]
            last0 = start
            start += 1
            stop -= 1
        end
        if start >= stop
            if (x[stop] & mask) == 0
                last0 = stop
            end
            return last0
        end
    end
end
