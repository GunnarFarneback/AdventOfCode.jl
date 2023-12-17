function part1(input)
    s = 0
    empty!(cache)
    for line in eachline(input)
        a, b = split(line)
        s += evaluate(collect(a), parse.(Int, split(b, ",")))
    end
    return s
end

function part2(input)
    s = 0
    empty!(cache)
    for line in eachline(input)
        a, b = split(line)
        a = join(repeat([a], 5), "?")
        b = join(repeat([b], 5), ",")
        n = evaluate_big(collect(a), parse.(Int, split(b, ",")))
        s += n
    end
    return s
end

function evaluate_big(x, y)
    count(==('#'), x) > sum(y) && return 0
    length(x) < sum(y) + length(y) - 1 && return 0
    if length(x) <= 13
        return evaluate(x, y)
    end
    i = (length(x) + 1) ÷ 2
    if x[i] == '?'
        x2 = copy(x)
        y2 = copy(y)
        x[i] = '.'
        x2[i] = '#'
        n1 = evaluate_big(x, y)
        n2 = evaluate_big(x2, y2)
        return n1 + n2
    elseif x[i] == '.'
        s = 0
        for j = 0:length(y)
            x1 = x[1:(i-1)]
            x2 = x[(i+1):end]
            s += evaluate_big(x1, y[1:j]) * evaluate_big(x2, y[(j + 1):end])
        end
        return s
    else
        s = 0
        for j = 1:length(y)
            c = y[j]
            for k = 1:c
                x1 = x[1:(i-1)]
                x2 = x[(i+1):end]
                y1 = y[1:(j-1)]
                y2 = y[(j + 1):end]
                k1 = k - 1
                k2 = c - k
                if k1 == 0
                    if x1[end] == '#'
                        continue
                    else
                        pop!(x1)
                    end
                    n1 = evaluate_big(x1, y1)
                else
                    if x1[end] == '.'
                        continue
                    end
                    x1[end] = '#'
                    push!(y1, k1)
                    n1 = evaluate_big(x1, y1)
                end
                if k2 == 0
                    if x2[1] == '#'
                        continue
                    else
                        popfirst!(x2)
                    end
                    n2 = evaluate_big(x2, y2)
                else
                    if x2[1] == '.'
                        continue
                    end
                    x2[1] = '#'
                    pushfirst!(y2, k2)
                    n2 = evaluate_big(x2, y2)
                end
                s += n1 * n2
            end
        end
        return s
    end
end

const cache = Dict{Tuple{Vector{Char}, Vector{Int}}, Int}()

function evaluate(x, y)
    return get!(cache, (x, y)) do
        _evaluate(copy(x), copy(y))
    end
end

function _evaluate(x, y)
    if isempty(x)
        return isempty(y)
    end
    if first(x) == '.'
        popfirst!(x)
        return evaluate(x, y)
    elseif first(x) == '?'
        x2 = copy(x)
        y2 = copy(y)
        x[1] = '.'
        x2[1] = '#'
        return evaluate(x, y) + evaluate(x2, y2)
    end
    isempty(y) && return 0
    if length(x) > 1 && x[2] == '?'
        x2 = copy(x)
        y2 = copy(y)
        x[2] = '.'
        x2[2] = '#'
        return evaluate(x, y) + evaluate(x2, y2)
    elseif length(x) > 1 && x[2] == '#'
        y[1] < 2 && return 0
        popfirst!(x)
        y[1] -= 1
        return evaluate(x, y)
    end
    y[1] == 1 || return 0
    popfirst!(x)
    if !isempty(x)
        popfirst!(x)
    end
    popfirst!(y)
    return evaluate(x, y)
end
