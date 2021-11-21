function part1(input)
    rules = parse_rules(input)
    return count(x -> "shiny gold" in x,
                 values(transitive_contained_colors(rules)))
end

function part2(input)
    rules = parse_rules(input)
    required_bags = 0
    queue = Dict("shiny gold" => 1)
    while !isempty(queue)
        color, quantity = pop!(queue)
        required_bags += quantity
        for (color2, quantity2) in rules[color]
            queue[color2] = get(queue, color2, 0) + quantity * quantity2
        end
    end
    return required_bags - 1
end

function parse_rules(input)
    rules = Dict{String, Dict{String, Int}}()
    for line in readlines(input)
        parse_rule!(rules, line)
    end
    return rules
end

function parse_rule!(rules, line)
    outer, inner = match(r"(.+) bags contain (.+)", line).captures
    rule = get!(rules, outer, Dict{String, Int}())
    inner == "no other bags." && return
    for contained in split(inner, ", ")
        quantity, color = match(r"(\d)+ (.+) bag", contained).captures
        rule[color] = parse(Int, quantity)
    end
end

function transitive_contained_colors(rules)
    contained_colors = Dict{String, Vector{String}}()
    for color in keys(rules)
        found_colors = collect(keys(rules[color]))
        i = 1
        while i <= length(found_colors)
            new_colors = setdiff(keys(rules[found_colors[i]]), found_colors)
            append!(found_colors, new_colors)
            i += 1
        end
        contained_colors[color] = found_colors
    end
    return contained_colors
end
