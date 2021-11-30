function part1(input, number_of_moves = "100")
    order = parse.(Int, split(readchomp(input), ""))
    state, current = order_to_state(order)
    for _ in 1:parse(Int, number_of_moves)
        current = move!(state, current)
    end
    order = state_to_order(state, 1)
    return string(order[2:end]...)
end

function part2(input, number_of_moves = "10000000")
    order = parse.(Int, split(readchomp(input), ""))
    append!(order, (length(order) + 1):1_000_000)
    @assert length(order) == 1_000_000
    state, current = order_to_state(order)
    for _ in 1:parse(Int, number_of_moves)
        current = move!(state, current)
    end
    order = state_to_order(state, 1)
    return order[2] * order[3]
end

function order_to_state(order)
    state = zeros(Int, length(order))
    for i = 2:length(order)
        state[order[i - 1]] = order[i]
    end
    state[order[end]] = order[1]
    return state, order[1]
end

function state_to_order(state, first)
    order = zeros(Int, length(state))
    i = first
    for j = 1:length(state)
        order[j] = i
        i = state[i]
    end
    return order
end

function move!(state, current)
    removed1 = state[current]
    removed2 = state[removed1]
    removed3 = state[removed2]
    next_current = state[removed3]
    state[current] = next_current
    destination = current - 1
    while true
        if destination == 0
            destination = length(state)
        end
        if destination == removed1 || destination == removed2 || destination == removed3
            destination -= 1
            continue
        end
        break
    end
    state[removed3] = state[destination]
    state[destination] = removed1
    return next_current
end
