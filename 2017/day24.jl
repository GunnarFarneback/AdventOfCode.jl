function part1(input)
    components, ports = parse_input(input)
    visited = Set{Int}()
    strength = 0
    max_strength = Ref(0)
    max_length = Ref((0, 0))
    dfs(components, ports, 0, 0, 0, visited, max_strength, max_length)
    return max_strength[]
end

function part2(input)
    components, ports = parse_input(input)
    visited = Set{Int}()
    strength = 0
    max_strength = Ref(0)
    max_length = Ref((0, 0))
    dfs(components, ports, 0, 0, 0, visited, max_strength, max_length)
    return last(max_length[])
end

function parse_input(input)
    components = map(line -> parse.(Int, split(line, "/")), eachline(input))
    ports = Dict{Int, Vector{Int}}()
    for (i, component) in enumerate(components)
        for port in component
            union!(get!(ports, port, Int[]), i)
        end
    end
    return components, ports
end

function dfs(components, ports, port, length, strength, visited,
             max_strength, max_length)
    for component in ports[port]
        component in visited && continue
        push!(visited, component)
        other_port = first(components[component])
        if other_port == port
            other_port = last(components[component])
        end
        strength += port + other_port
        if strength > max_strength[]
            max_strength[] = strength
        end
        if (length + 1, strength) > max_length[]
            max_length[] = (length + 1, strength)
        end
        dfs(components, ports, other_port, length + 1, strength, visited,
            max_strength, max_length)
        pop!(visited, component)
        strength -= port + other_port
    end
end
