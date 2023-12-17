function part1(input)
    maps = parse_map.(split(readchomp(input), "\n\n"))
    return sum(maps) do m
        symmetries(m, 0) + 100 * symmetries(permutedims(m), 0)
    end
end

function part2(input)
    maps = parse_map.(split(readchomp(input), "\n\n"))
    return sum(maps) do m
        symmetries(m, 1) + 100 * symmetries(permutedims(m), 1)
    end
end

parse_map(x) = stack(split(x, "\n"))

function symmetries(m::AbstractMatrix, n::Int)
    defects = findall(==(n), sum(symmetries.(eachcol(m))))
    length(defects) == 0 && return 0
    return only(defects)
end

symmetries(v::AbstractVector) = [symmetries(v, i) for i in 1:(length(v) - 1)]

symmetries(v::AbstractVector, i::Int) =
    sum(v[i - j + 1] != v[i + j] for j in 1:(min(i, length(v) - i)))
