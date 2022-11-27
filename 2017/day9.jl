function part1(input)
    return first(analyze_garbage(input))
end

function part2(input)
    return last(analyze_garbage(input))
end

function analyze_garbage(input)
    data = split(readchomp(input), "")
    score = 0
    depth = 0
    inside_garbage = false
    num_garbage = 0
    i = 1
    while i <= length(data)
        c = data[i]
        if inside_garbage
            if c == ">"
                inside_garbage = false
            elseif c == "!"
                i += 1
            else
                num_garbage += 1
            end
        else
            if c == "{"
                depth += 1
                score += depth
            elseif c == "<"
                inside_garbage = true
            elseif c == "}"
                depth -= 1
            end
        end
        i += 1
    end
    @assert depth == 0
    return score, num_garbage
end
