function part1(input)
    banks = parse.(Int, split(readchomp(input), "\t"))
    return run_reallocation(banks)
end

function part2(input)
    banks = parse.(Int, split(readchomp(input), "\t"))
    return run_reallocation(banks, part = 2)
end

function run_reallocation(banks; part = 1)
    seen = Dict(copy(banks) => 0)
    n = 0
    while true
        n += 1
        redistribute!(banks)
        if haskey(seen, banks)
            if part == 1
                return n
            else
                return n - seen[banks]
            end
        end
        seen[copy(banks)] = n
    end
end

function redistribute!(banks)
    n, i = findmax(banks)
    banks[i] = 0
    for j = 1:n
        banks[mod1(i + j, length(banks))] += 1
    end
end
