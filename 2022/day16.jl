struct Valve
    name::String
    rate::Int
    exits::Vector{String}
end

function part1(input)
    valves = parse_line.(eachline(input))
    valves_dict = Dict(valve.name => valve for valve in valves)
    state = ("AA", Set{String}())
    states = Dict(state => 0)
    visited = Set(state)
    best_score = 0
    for i = 1:30
        next_states = empty(states)
        for (state, score) in states
            name, released = state
            valve = valves_dict[name]
            if valve.rate > 0 && name ∉ released
                new_score = score + valve.rate * (30 - i)
                best_score = max(best_score, new_score)
                new_released = push!(copy(released), name)
                new_state = (name, new_released)
                if new_state ∉ visited
                    next_states[new_state] = max(new_score, get(next_states, new_state, 0))
                end
            end
            for exit in valve.exits
                new_state = (exit, released)
                if new_state ∉ visited
                    next_states[new_state] = max(score, get(next_states, new_state, 0))
                end
            end
        end
        for (state, _) in states
            push!(visited, state)
        end
        states = next_states
    end
    return best_score
end

function part2(input)
    valves = parse_line.(eachline(input))
    valves_dict = Dict(valve.name => valve for valve in valves)
    state = ("AA", "AA", Set{String}())
    states = Dict(state => 0)
    visited = Set(state)
    best_score = 0
    for i = 1:26
        next_states = empty(states)
        for (state, score) in states
            name1, name2, released = state
            valve = valves_dict[name1]
            if valve.rate > 0 && name1 ∉ released
                new_score = score + valve.rate * (26 - i)
                best_score = max(best_score, new_score)
                new_released = push!(copy(released), name1)
                new_state = (name1, name2, new_released)
                if (min(name1, name2), max(name1, name2), released) ∉ visited
                    next_states[new_state] = max(new_score, get(next_states, new_state, 0))
                end
            end
            for exit in valve.exits
                new_state = (exit, name2, released)
                if (min(exit, name2), max(exit, name2), released) ∉ visited
                    next_states[new_state] = max(score, get(next_states, new_state, 0))
                end
            end
        end
        states1 = states
        states = next_states
        next_states = empty(states)
        for (state, score) in states
            name1, name2, released = state
            valve = valves_dict[name2]
            if valve.rate > 0 && name2 ∉ released
                new_score = score + valve.rate * (26 - i)
                best_score = max(best_score, new_score)
                new_released = push!(copy(released), name2)
                new_state = (name1, name2, new_released)
                if (min(name1, name2), max(name1, name2), released) ∉ visited
                    next_states[new_state] = max(new_score, get(next_states, new_state, 0))
                end
            end
            for exit in valve.exits
                new_state = (name1, exit, released)
                if (min(name1, exit), max(name1, exit), released) ∉ visited
                    next_states[new_state] = max(score, get(next_states, new_state, 0))
                    end
            end
        end
        for (state, _) in states
            name1, name2, released = state
            if name1 > name2
                name1, name2 = name2, name1
            end
            push!(visited, (name1, name2, released))
        end
        for (state, _) in states1
            name1, name2, released = state
            if name1 > name2
                name1, name2 = name2, name1
            end
            push!(visited, (name1, name2, released))
        end
        states = next_states
    end
    return best_score
end

function parse_line(line)
    a, b, c = match(r"Valve ([A-Z][A-Z]) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line).captures
    return Valve(a, parse(Int, b), split(c, ", "))
end
