function part1(input)
    x1, x2, y1, y2 = parse.(Int, match(r"target area: x=([-\d]+)\.\.([-\d]+), y=([-\d]+)\.\.([-\d]+)", readchomp(input)).captures)
    @assert y1 < 0 && x1 > 0
    @assert any(x1 <= sum(1:t) <= x2 for t in 1:-y1)
    return sum(1:(-1 - y1))
end

function part2(input)
    x1, x2, y1, y2 = parse.(Int, match(r"target area: x=([-\d]+)\.\.([-\d]+), y=([-\d]+)\.\.([-\d]+)", readchomp(input)).captures)
    X = Dict{Int, Set{Int}}()
    Y = Dict{Int, Set{Int}}()
    for x = 1:x2
        X[x] = find_x(x, x1, x2, 5 - 2 * y1)
    end
    for y = y1:(-y1)
        Y[y] = find_y(y, y1, y2)
    end
    t = 0
    Z = Set{Tuple{Int, Int}}()
    XX = Int[]
    YY = Int[]
    while true
        t += 1
        empty!(XX)
        empty!(YY)
        for y in collect(keys(Y))
            if t in Y[y]
                push!(YY, y)
                pop!(Y[y], t)
            end
            if isempty(Y[y])
                delete!(Y, y)
            end
        end
        isempty(YY) && continue
        for x in collect(keys(X))
            if t in X[x]
                push!(XX, x)
                pop!(X[x], t)
            end
            if isempty(X[x])
                delete!(X, x)
            end
        end
            
        for y in YY, x in XX
            push!(Z, (x, y))
        end
        if isempty(X) || isempty(Y)
            return length(Z)
        end
    end
end

function find_x(v, x1, x2, max_t)
    T = Set{Int}()
    t = 0
    x = 0
    while true
        t += 1
        x += v
        v = max(0, v - 1)
        if x1 <= x <= x2
            push!(T, t)
        end
        if x > x2 || t > max_t
            return T
        end
    end
end

function find_y(v, y1, y2)
    T = Set{Int}()
    t = 0
    y = 0
    while true
        t += 1
        y += v
        v -= 1
        if y1 <= y <= y2
            push!(T, t)
        end
        if y < y1
            return T
        end
    end
end
