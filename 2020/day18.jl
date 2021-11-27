function part1(input)
    return sum(eval_line1.(readlines(input)))
end

function part2(input)
    return sum(eval_line2.(readlines(input)))
end

function eval_line1(line)
    expr = Meta.parse(replace(replace(line, "+" => "⊙"), "*" => "⊗"))
    return eval(expr)
end

⊙(x, y) = x + y
⊗(x, y) = x * y

function eval_line2(line)
    expr = Meta.parse(replace(replace(line, "+" => "⊠"), "*" => "⊞"))
    return eval(expr)
end

⊠(x, y) = x + y
⊞(x, y) = x * y
