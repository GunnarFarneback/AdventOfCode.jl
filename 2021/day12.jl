function part1(input)
    start = map_cave(input)
    n = Ref(0)
    find_paths(start, n, false)
    return n[]
end

function part2(input)
    start = map_cave(input)
    n = Ref(0)
    find_paths(start, n, true)
    return n[]
end

mutable struct Cave
    name::Symbol
    small::Bool
    visited::Bool
    neighbors::Vector{Cave}
end

Cave(name) = Cave(Symbol(name), all(islowercase, collect(name)), false, Cave[])

function map_cave(input)
    caves = Dict{String, Cave}()
    for line in eachline(input)
        cave1, cave2 = get_cave.(Ref(caves), split(line, "-"))
        push!(cave1.neighbors, cave2)
        push!(cave2.neighbors, cave1)
    end
    return caves["start"]
end

get_cave(caves, name) = get!(() -> Cave(name), caves, name)

function find_paths(cave, n, allow_second_visit)
    if cave.name == :end
        n[] += 1
        return
    end
    second_visit = false
    if cave.small && cave.visited
        if !allow_second_visit || cave.name == :start
            return
        end
        second_visit = true
        allow_second_visit = false
    end
    cave.visited = true
    for neighbor in cave.neighbors
        find_paths(neighbor, n, allow_second_visit)
    end
    if !second_visit
        cave.visited = false
    end
end
