function part1(input)
    return sum(n for (n, games) in parse_input(input)
               if all(all(game .<= [12, 13, 14]) for game in games))
end

function part2(input)
    return sum(prod(maximum(stack(games), dims = 2))
               for games in values(parse_input(input)))
end

function parse_input(input)
    return Dict(n => games for (n, games) in parse_line.(eachline(input)))
end

function parse_line(line)
    n, games = split(line, ": ")
    return parse(Int, last(split(n, " "))), parse_games(games)
end

function parse_games(games)
    return parse_game.(split(games, "; "))
end

function parse_game(game)
    r = g = b = 0
    for balls in split(game, ", ")
        number, color = split(balls, " ")
        n = parse(Int, number)
        if color == "red"
            r = n
        elseif color == "green"
            g = n
        elseif color == "blue"
            b = n
        end
    end
    return [r, g, b]
end
