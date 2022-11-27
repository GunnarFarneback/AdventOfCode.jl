function part1(input)
    graph = read_graph(input)
    return length(find_connected_component(graph, 0))
end

function part2(input)
    graph = read_graph(input)
    seen = Set{Int}()
    num_components = 0
    for node in keys(graph)
        if node ∉ seen
            component = find_connected_component(graph, node)
            union!(seen, component)
            num_components += 1
        end
    end
    return num_components
end

function read_graph(input)
    graph = Dict{Int, Vector{Int}}()
    for line in eachline(input)
        source, targets = split(line, " <-> ")
        graph[parse(Int, source)] = parse.(Int, split(targets, ", "))
    end
    return graph
end

function find_connected_component(graph, start)
    connected_component = Set{Int}(start)
    queue = [start]
    while !isempty(queue)
        node = popfirst!(queue)
        for neighbor in graph[node]
            if neighbor ∉ connected_component
                push!(connected_component, neighbor)
                push!(queue, neighbor)
            end
        end
    end
    return connected_component
end
