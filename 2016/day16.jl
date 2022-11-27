function part1(input)
    sequence = [c == '1' for c in readchomp(input)]
    return compute_checksum(sequence, 272)
end

function part2(input)
    sequence = [c == '1' for c in readchomp(input)]
    return compute_checksum(sequence, 35651584)
end

function compute_checksum(sequence, N)
    while length(sequence) < N
        expand!(sequence)
    end
    deleteat!(sequence, (N + 1):length(sequence))
    while length(sequence) % 2 == 0
        reduce!(sequence)
    end
    return join(string.(Int.(sequence)))
end

expand!(x) = append!(x, false, .!(reverse(x)))

function reduce!(x)
    for i = 1:(length(x) ÷ 2)
        x[i] = x[2 * i - 1] == x[2 * i]
    end
    deleteat!(x, (length(x) ÷ 2 + 1):length(x))
end
