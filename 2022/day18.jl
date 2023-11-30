function part1(input)
    cubes = [tuple(parse.(Int, split(line, ","))...) for line in eachline(input)]
    return 6 * length(cubes) - count(sum(abs.(c1 .- c2)) == 1 for c1 in cubes, c2 in cubes)
end

function part2(input)
    cubes = Set(tuple(parse.(Int, split(line, ","))...) for line in eachline(input))
    air = [(i1, i2, i3)
           for i1 in extended_range(c[1] for c in cubes),
           i2 in extended_range(c[2] for c in cubes),
           i3 in extended_range(c[3] for c in cubes)
           if (i1, i2, i3) ∉ cubes]
    visited = Set(Ref(first(air)))
    queue = [first(air)]
    exterior_area = 0
    while !isempty(queue)
        x = popfirst!(queue)
        for dn in ((-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1))
            n = x .+ dn
            if n ∉ visited
                if n in cubes
                    exterior_area += 1
                elseif n in air
                    push!(visited, n)
                    push!(queue, n)
                end
            end
        end
    end
    return exterior_area
end

extended_range(c) = range((extrema(c) .+ (-1, 1))...)
