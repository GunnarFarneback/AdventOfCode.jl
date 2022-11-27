function part1(input)
    data = read_input(input)
    return only(setdiff(keys(data),
                        reduce(vcat, (node.children for node in values(data)))))
end

function part2(input)
    data = read_input(input)
    bottom = only(setdiff(keys(data),
                          reduce(vcat, (node.children
                                        for node in values(data)))))
    compute_total_weight!(data, bottom)
    smallest_balanced_total_weight = data[bottom].total_weight
    corrected_weight = -1
    for node in values(data)
        isempty(node.children) && continue
        total_child_weights = [data[child].total_weight
                               for child in node.children]
        unique_total_weights = unique(total_child_weights)
        length(unique_total_weights) == 1 && continue
        if count(==(first(unique_total_weights)), total_child_weights) > 1
            reverse!(unique_total_weights)
        end
        if last(unique_total_weights) < smallest_balanced_total_weight
            i = findfirst(==(first(unique_total_weights)), total_child_weights)
            corrected_weight = data[node.children[i]].weight + only(diff(unique_total_weights))
            smallest_balanced_total_weight = last(unique_total_weights)
        end
    end
    return corrected_weight
end

mutable struct Node
    name::String
    weight::Int
    total_weight::Int
    children::Vector{String}
end

function read_input(input)
    data = Dict{String, Node}()
    for line in eachline(input)
        parse_line!(data, line)
    end
    return data
end

function parse_line!(data, line)
    parts = split(line, " -> ")
    name, weight = split(parts[1], " (")
    weight = rstrip(weight, ')')
    children = String[]
    if length(parts) > 1
        children = string.(split(parts[2], ", "))
    end
    data[name] = Node(name, parse(Int, weight), -1, children)
end

function compute_total_weight!(data, node)
    total_child_weight = sum((compute_total_weight!(data, child)
                              for child in data[node].children); init = 0)
    data[node].total_weight = data[node].weight + total_child_weight
    return data[node].total_weight
end
