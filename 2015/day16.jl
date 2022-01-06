function part1(input)
    sues = reduce(hcat, parse_line.(eachline(input)))
    true_sue = Dict("children" => 3,
                    "cats" => 7,
                    "samoyeds" => 2,
                    "pomeranians" => 3,
                    "akitas" => 0,
                    "vizslas" => 0,
                    "goldfish" => 5,
                    "trees" => 3,
                    "cars" => 2,
                    "perfumes" => 1)
    for (i, sue) in enumerate(sues)
        all(true_sue[key] == value for (key, value) in sue) && return i
    end
end

function part2(input)
    sues = reduce(hcat, parse_line.(eachline(input)))
    true_sue = Dict("children" => ==(3),
                    "cats" => >(7),
                    "samoyeds" => ==(2),
                    "pomeranians" => <(3),
                    "akitas" => ==(0),
                    "vizslas" => ==(0),
                    "goldfish" => <(5),
                    "trees" => >(3),
                    "cars" => ==(2),
                    "perfumes" => ==(1))
    for (i, sue) in enumerate(sues)
        all(true_sue[key](value) for (key, value) in sue) && return i
    end
end

function parse_line(line)
    facts = Dict{String, Int}()
    for part in split(line, ", ")
        pieces = split(part, ": ")
        facts[pieces[end - 1]] = parse(Int, pieces[end])
    end
    return facts
end
