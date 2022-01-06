part1(input) = length(filter(isnice1, readlines(input)))
part2(input) = length(filter(isnice2, readlines(input)))

function isnice1(word)
    for bad in ("ab", "cd", "pq", "xy")
        occursin(bad, word) && return false
    end
    vowels = 0
    doubles = 0
    last_c = ' '
    for c in word
        if c in ('a', 'e', 'i', 'o', 'u')
            vowels += 1
        end
        if c == last_c
            doubles += 1
        end
        last_c = c
    end
    return vowels >= 3 && doubles >= 1
end

function isnice2(word)
    double_pair_found = false
    repeated_found = false
    last_c = ' '
    second_last_c = ' '
    pairs = Set{Tuple{Char, Char}}()
    for c in word
        if c == second_last_c
            repeated_found = true
        end
        if (last_c, c) in pairs
            double_pair_found = true
        end
        push!(pairs, (second_last_c, last_c))
        second_last_c = last_c
        last_c = c
    end
    return double_pair_found && repeated_found
end
