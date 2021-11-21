function part1(input)
    return sum(count_score1.(split(read(input, String), "\n\n")))
end

function part2(input)
    return sum(count_score2.(split(read(input, String), "\n\n")))
end

function count_score1(s)
    s = replace(s, "\n" => "")
    return length(unique(split(s, "")))
end

function count_score2(s)
    answers = split(s, "\n", keepempty = false)
    counts = Dict{String, Int}()
    for answer in answers
        for question in unique(split(answer, ""))
            counts[question] = get(counts, question, 0) + 1
        end
    end
    return count(==(length(answers)), values(counts))
end
