struct Expression
    f::Function
    x::String
    y::String
end

struct Affine
    a::Rational{Int}
    b::Rational{Int}
end

Affine(b) = Affine(0, b)

Base.:+(x::Affine, y::Affine) = Affine(x.a + y.a, x.b + y.b)
Base.:-(x::Affine, y::Affine) = Affine(x.a - y.a, x.b - y.b)

function Base.:*(x::Affine, y::Affine)
    @assert x.a * y.a == 0
    return Affine(x.a * y.b + x.b * y.a, x.b * y.b)
end

function Base.:/(x::Affine, y::Affine)
    @assert y.a == 0
    return Affine(x.a / y.b, x.b / y.b)
end

function part1(input)
    expressions, values = parse_input(input)
    return evaluate("root", expressions, values)
end

function part2(input)
    expressions, values = parse_input(input, Affine)
    values["humn"] = Affine(1, 0)
    expressions["root"] = Expression(-, expressions["root"].x,
                                     expressions["root"].y)
    root = evaluate("root", expressions, values)
    return -Int(root.b / root.a)
end

function parse_input(input, T = Int)
    expressions = Dict{String, Expression}()
    values = Dict{String, T}()
    for line in eachline(input)
        name, v = split(line, ": ")
        if isdigit(first(v))
            values[name] = T(parse(Int, v))
        else
            x, f, y = split(v, " ")
            expressions[name] = Expression(getfield(Base, Symbol(f)), x, y)
        end
    end
    return expressions, values
end

function evaluate(name, expressions, values)
    if !haskey(values, name)
        (;f, x, y) = expressions[name]
        values[name] = f(evaluate(x, expressions, values),
                         evaluate(y, expressions, values))
    end
    return values[name]
end
