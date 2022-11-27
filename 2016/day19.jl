function part1(input)
    n = parse(Int, readchomp(input))
    next_elf = mod1.(2:(n + 1), n)
    i = 1
    while next_elf[i] != i
        next_elf[i] = next_elf[next_elf[i]]
        i = next_elf[i]
    end
    return i
end

function part2(input)
    n = parse(Int, readchomp(input))
    next_elf = mod1.(2:(n + 1), n)
    i = n ÷ 2
    while n > 1
        next_elf[i] = next_elf[next_elf[i]]
        n -= 1
        if n % 2 == 0
            i = next_elf[i]
        end
    end
    return i
end
