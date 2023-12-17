function part1(input)
    instructions, nodes = parse_input(input)
    return travel(nodes, instructions, "AAA", "ZZZ")
end

function part2(input)
    instructions, nodes = parse_input(input)
    start_nodes = filter(endswith("A"), keys(nodes))
    return lcm((travel(nodes, instructions, node, "Z")
                for node in start_nodes)...)
end

function parse_input(input)
    lines = readlines(input)
    instructions = collect(lines[1])
    nodes = Dict(name => Dict('L' => left, 'R' => right)
                 for line in lines[3:end]
                 for (name, left, right) in (split(line, collect(" =,()"),
                                                   keepempty = false),))
    return instructions, nodes
end

function travel(nodes, instructions, node, target)
    i = 0
    while !endswith(node, target)
        i += 1
        node = nodes[node][instructions[mod1(i, length(instructions))]]
    end
    return i
end
