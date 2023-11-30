function part1(input)
    filesystem = parse_input(input)
    sizes = Int[]
    find_directory_sizes!(sizes, filesystem)
    return sum(x for x in sizes if x <= 100000)
end

function part2(input)
    filesystem = parse_input(input)
    sizes = Int[]
    used = find_directory_sizes!(sizes, filesystem)
    free = 70000000 - used
    missing_space = 30000000 - free
    return minimum(filter(>=(missing_space), sizes))
end

function parse_input(input)
    stack = []
    filesystem = Dict("/" => Dict())
    current_directory = filesystem
    for line in eachline(input)
        if startswith(line, "\$ cd ..")
            current_directory = pop!(stack)
        elseif startswith(line, "\$ cd")
            name = line[6:end]
            push!(stack, current_directory)
            current_directory = current_directory[name]
        elseif startswith(line, "\$ ls")
        elseif startswith(line, "dir")
            name = line[5:end]
            current_directory[name] = Dict()
        else
            filesize, name = split(line)
            current_directory[name] = parse(Int, filesize)
        end
    end
    return filesystem
end

function find_directory_sizes!(sizes, directory::Dict)
    size = sum(child -> find_directory_sizes!(sizes, child),
               values(directory))
    push!(sizes, size)
    return size
end

find_directory_sizes!(sizes, filesize::Int) = filesize
