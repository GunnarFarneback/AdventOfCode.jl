function part1(input)
    x = parse.(Int, eachline(input))
    return decode(x, 1, 1)
end

function part2(input)
    x = parse.(Int, eachline(input))
    return decode(x, 811589153, 10)
end

function decode(x, key, rounds)
    if key != 1
        x .*= key
    end
    N = length(x)
    Nhalf = (N - 1) ÷ 2
    next = vcat(0x0002:UInt16(N), 0x0001)
    prev = vcat(UInt16(N), 0x0001:(UInt16(N) - 0x0001))
    for _ in 1:rounds
        for i in 1:N
            k = x[i]
            k = mod(x[i], N - 1)
            if k > Nhalf
                k -= N - 1
            end
            j = next[i]
            next[prev[i]] = next[i]
            prev[next[i]] = prev[i]
            if k > 0
                for _ in 1:k
                    j = next[j]
                end
            elseif k < 0
                for _ in 1:(-k)
                    j = prev[j]
                end
            end
            prev[i] = prev[j]
            next[i] = j
            next[prev[j]] = i
            prev[j] = i
        end
    end

    i = findfirst(==(0), x)
    s = 0
    for _ in 1:3
        for _ in 1:1000
            i = next[i]
        end
        s += x[i]
    end
    return s
end
