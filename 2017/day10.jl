function part1(input)
    lengths = parse.(Int, split(readchomp(input), ","))
    x = compute_knot_hash(lengths, rounds = 1)
    return x[1] * x[2]
end

function part2(input)
    lengths = vcat(Int.(read(input)[1:(end - 1)]))
    hash = compute_knot_hash(lengths)
    return bytes2hex(UInt8.(hash))
end

compute_knot_hash(key::String) = compute_knot_hash(Int.(codeunits(key)))

function compute_knot_hash(lengths; rounds = 64)
    if rounds > 1
        append!(lengths, [17, 31, 73, 47, 23])
    end
    x = collect(0:255)
    N = length(x)
    pos = 0
    skip = 0
    for round = 1:rounds
        for l in lengths
            if l > 1
                I = 1 .+ mod.(pos:(pos + l - 1), N)
                x[I] .= reverse(x[I])
            end
            pos += l + skip
            skip += 1
        end
    end
    @assert sort(x) == 0:255
    rounds == 1 && return x
    dense_hash = [xor(x[i:(i + 15)]...) for i = 1:16:255]
    return dense_hash
end
