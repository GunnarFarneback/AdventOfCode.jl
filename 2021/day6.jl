part1(input) = simulate(input, 80)
part2(input) = simulate(input, 256)

function simulate(input, n)
    state = zeros(Int, 9)
    for age in parse.(Int, split(readchomp(input), ","))
        state[age + 1] += 1
    end
    for i = 1:n
        state0 = state[1]
        state[1:8] .= state[2:9]
        state[9] = state0
        state[7] += state0
    end
    return sum(state)
end
