function part1(input)
    return count(n -> n in (2, 3, 4, 7), length.(reduce(vcat, last.(parse_input(input)))))
end

function part2(input)
    return sum(decode.(parse_input(input)))
end

parse_input(input) = parse_line.(readlines(input))

parse_line(line) = split.(split(line, " | "))

function decode(data)
    in_data, out_data = data
    display_digits = ["abcefg", "cf", "acdeg", "acdfg", "bcdf",
                      "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
    encoded_digits = encode.(display_digits, 1, 2, 3, 4, 5, 6, 7)
    sorted_digits = sort(encoded_digits)

    for a in 1:7, b in 1:7, c in 1:7, d in 1:7, e in 1:7, f in 1:7, g in 1:7
        length(unique([a, b, c, d, e, f, g])) == 7 || continue
        digits = Int[]
        for D in in_data
            n = encode(D, a, b, c, d, e, f, g)
            push!(digits, n)
        end
        if sort(digits) == sorted_digits
            v = 0
            for D in out_data
                v *= 10
                n = encode(D, a, b, c, d, e, f, g)
                v += findfirst(encoded_digits .== n) - 1
            end
            return  v
        end
    end
    @assert false
end

function encode(D, a, b, c, d, e, f, g)
    n = 0
    for C in D
        C == 'a' && (n |= 1 << a)
        C == 'b' && (n |= 1 << b)
        C == 'c' && (n |= 1 << c)
        C == 'd' && (n |= 1 << d)
        C == 'e' && (n |= 1 << e)
        C == 'f' && (n |= 1 << f)
        C == 'g' && (n |= 1 << g)
    end
    return n
end
