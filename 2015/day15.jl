using Combinatorics

function part1(input)
    ingredients = reduce(hcat, parse_line.(eachline(input)))
    return foldl(max, (score1(ingredients[1:(end - 1), :], proportions)
                       for proportions1 in partitions(100, size(ingredients, 2))
                       for proportions in permutations(proportions1)))
end

function part2(input)
    ingredients = reduce(hcat, parse_line.(eachline(input)))
    return foldl(max, (score2(ingredients, proportions)
                       for proportions1 in partitions(100, size(ingredients, 2))
                       for proportions in permutations(proportions1)))
end

parse_line(line) = parse.(Int, rstrip.(split(line)[3:2:11], ','))

score1(ingredients, proportions) = prod(max.(0, ingredients * proportions))

function score2(ingredients, proportions)
    n = max.(0, ingredients * proportions)
    return prod(n[1:(end - 1)]) * (n[end] == 500)
end
