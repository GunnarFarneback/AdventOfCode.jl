const openers = "([{<"
const closers = ")]}>"
const corrupted_scores = [3, 57, 1197, 25137]
const incomplete_scores = [1, 2, 3, 4]

part1(input) = sum(check_line.(eachline(input), part = 1))

function part2(input)
    scores = check_line.(eachline(input), part = 2)
    return sort(filter(>(0), scores))[(1 + end) ÷ 2]
end

function check_line(line; part)
    stack = Char[]
    for c in line
        if c in openers
            push!(stack, c)
        elseif c in closers
            if findfirst(c, closers) != findfirst(pop!(stack), openers)
                part == 1 && return corrupted_scores[findfirst(c, closers)]
                part == 2 && return 0
            end
        end
    end
    part == 1 && return 0
    part == 2 && return foldl((x, y) -> 5 * x + y,
                              (incomplete_scores[findfirst(c, openers)]
                               for c in reverse(stack)))
end
