function part1(input)
    public_keys = parse.(Int, readlines(input))
    secret_keys = find_log7.(public_keys)
    encryption_key1 = pow(public_keys[1], secret_keys[2])
    encryption_key2 = pow(public_keys[2], secret_keys[1])
    @assert encryption_key1 == encryption_key2
    return encryption_key1
end

function part2(input)
end

function find_log7(n)
    i = 0
    m = 1
    while m != n
        m *= 7
        i += 1
        if m > 20201227
            m = mod(m, 20201227)
        end
    end
    return i
end

function pow(b, n)
    m = 1
    for i = 1:n
        m *= b
        if m > 20201227
            m = mod(m, 20201227)
        end
    end
    return m
end
