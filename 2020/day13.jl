function part1(input)
    timestamp, bus_list = readlines(input)
    time = parse(Int, timestamp)
    buses = parse.(Int, filter(!=("x"), split(bus_list, ",")))
    wait_times = mod.(-time, buses)
    _, i = findmin(wait_times)
    return wait_times[i] * buses[i]
end

function part2(input)
    _, bus_list = readlines(input)
    buses = tryparse.(Int, split(bus_list, ","))
    modulo = BigInt(1)
    remainder = BigInt(0)
    for (i, n) in enumerate(buses)
        isnothing(n) && continue
        modulo, remainder = crt(modulo, remainder, BigInt(n), BigInt(1 - i))
    end
    return remainder
end

function crt(n1, r1, n2, r2)
    d, u, v = gcdx(n1, n2)
    n = n1 * n2 ÷ d
    return n, mod((r1 * n2 * v + r2 * n1 * u) ÷ d, n)
end
