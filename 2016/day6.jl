part1(input) = decode(input, argmax)
part2(input) = decode(input, argmin)

function decode(input, method)
    messages = readlines(input)
    decoded = ""
    for i = 1:length(first(messages))
        decoded *= method(count_characters([message[i] for message in messages]))
    end
    return decoded
end

function count_characters(x)
    counts = Dict{Char, Int}()
    for c in x
        counts[c] = get(counts, c, 0) + 1
    end
    return counts
end
