function part1(input)
    jumps = parse.(Int, eachline(input))
    return run!(jumps)
end

function part2(input)
    jumps = parse.(Int, eachline(input))
    return run!(jumps, part2 = true)
end

function run!(jumps; part2 = false)
    steps = 0
    pc = 1
    while pc <= length(jumps)
        n = jumps[pc]
        if !part2 || jumps[pc] < 3
            jumps[pc] += 1
        else
            jumps[pc] -= 1
        end
        pc += n
        steps += 1
    end
    return steps
end
