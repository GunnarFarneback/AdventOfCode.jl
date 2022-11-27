function part1(input)
    return sum(id for (code, id, checksum) in parse_line.(eachline(input))
               if is_real_room(code, checksum))
end

function part2(input)
    for (code, id, checksum) in parse_line.(eachline(input))
        is_real_room(code, checksum) || continue
        decoded = join(decode_letter.(collect(code), id))
        all(occursin.(["north", "pole", "object"], decoded)) && return decoded, id
    end
    @assert false
end

function parse_line(line)
    parts = split(line, "-")
    id = parse(Int, first(split(parts[end], "[")))
    checksum = line[(end - 5):(end - 1)]
    return join(parts[1:(end - 1)], "-"), id, checksum
end

function countchars(s)
    counts = Dict(c => 0 for c in unique(s))
    for c in s
        counts[c] += 1
    end
    delete!(counts, '-')
    return sort([(-n, c) for (c, n) in counts])
end

is_real_room(code, checksum) = join(last.(countchars(code)[1:5]), "") == checksum

function decode_letter(c, id)
    c == '-' && return ' '
    return mod((c - 'a') + id, 26) + 'a'
end
