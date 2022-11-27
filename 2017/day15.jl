function part1(input)
    state = parse.(Int, map(row -> last(split(row, " ")), eachline(input)))
    factors = [16807, 48271]
    modulo = 2147483647
    num_matches = 0
    for i = 1:40000000
        state = mod.(state .* factors, modulo)
        num_matches += state[1] & 0xffff == state[2] & 0xffff
    end
    return num_matches
end

function part2(input)
    A, B = parse.(Int, map(row -> last(split(row, " ")), eachline(input)))
    A_factor, B_factor = 16807, 48271
    modulo = 2147483647
    num_matches = 0
    for i = 1:5000000
        while true
            A = mod(A * A_factor, modulo)
            A & 3 == 0 && break
        end
        while true
            B = mod(B * B_factor, modulo)
            B & 7 == 0 && break
        end
        num_matches += A & 0xffff == B & 0xffff
    end
    return num_matches

end
