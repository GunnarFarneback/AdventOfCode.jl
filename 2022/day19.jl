function part1(input)
    blueprints = parse_line.(eachline(input))
    sum(i * harvest_geodes(blueprints[i], 24) for i in 1:length(blueprints))
end

function part2(input)
    blueprints = parse_line.(eachline(input))
    prod(harvest_geodes(blueprints[i], 32) for i in 1:3)
end

parse_line(line) = find_costs.(split(line, "costs")[2:5])

function find_costs(costs)
    return (find_cost(costs, r"(\d+) ore"),
            find_cost(costs, r"(\d+) clay"),
            find_cost(costs, r"(\d+) obsidian"),
            0)
end

function find_cost(costs, re)
    m = match(re, costs)
    isnothing(m) && return 0
    return parse(Int, only(m.captures))
end

function harvest_geodes(blueprint, time)
    start_state = ((0, 0, 0, 0), (1, 0, 0, 0))
    new_production = ((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1))
    stacks = [typeof(start_state)[] for _ in 1:time]
    push!(stacks[1], start_state)
    max_num_geodes = 0
    max_cost = (maximum(blueprint[j][k] for j in 1:4) for k in 1:3)
    for (i, stack) in enumerate(stacks)
        limits = ((max_cost .* (time + 1 - i))..., typemax(Int))
        while !isempty(stack)
            resources, production = pop!(stack)
            max_num_geodes = max(max_num_geodes, resources[4] + production[4] * (time + 1 - i))
            for j in 1:4
                if all((resources .+ (time - i) .* production) .>= blueprint[j])
                    di = 1 + max(0, ceil(Int, maximum((blueprint[j][k] - resources[k]) / max(1, production[k]) for k in 1:4)))
                    if i + di <= time
                        add_to_stack!(stacks[i + di], i + di,
                                      resources .+ di .* production .- blueprint[j],
                                      production .+ new_production[j], limits, time)
                    end
                end
            end
        end
    end
    return max_num_geodes
end

function add_to_stack!(stack, i, resources, production, limits, time)
    new_state = (resources, production)
    for j in reverse(eachindex(stack))
        old_dominates, new_dominates = dominates(stack[j], new_state,
                                                 time + 1 - i, limits)
        old_dominates && return
        new_dominates && deleteat!(stack, j)
    end
    push!(stack, new_state)
end

function dominates(a, b, n, limits)
    a_res, a_prod = a
    b_res, b_prod = b
    a_comp = min.(a_res .+ n .* a_prod, limits)
    b_comp = min.(b_res .+ n .* b_prod, limits)
    return all(a_comp .>= b_comp), all(a_comp .<= b_comp)
end
