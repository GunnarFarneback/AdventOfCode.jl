get_value(v) = v in ("w", "x", "y", "z") ? Symbol(v) : parse(Int, v)

function generate_function(i, program)
    name = Symbol("f$i")
    expr = Expr(:block, program...)
    @eval function $name(w, z)
        $expr
    end
end

function generate_functions(lines)
    i = 0
    program = []
    for line in lines
        parts = split(line)
        instruction = parts[1]
        target = Symbol(parts[2])
        value = get_value(parts[end])
        if instruction == "inp"
            @assert target == :w
            if i > 0
                generate_function(i, program)
            end
            i += 1
            program = []
        elseif instruction == "mul" && value == 0
                push!(program, :($target = 0))
        else
            op = Dict("add" => :+, "mul" => :*,
                      "div" => :÷, "mod" => :%, "eql" => :(==))[instruction]
            push!(program, :($target = $op($target, $value)))
        end
    end
    generate_function(i, program)
end

generate_functions(readlines(joinpath(@__DIR__, "input/day24")))

function run_monad(part)
    states = [(0, 0)]
    for f in (f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14)
        # @show length(states)
        iterate_monad!(states, f, part)
    end
    @assert first(first(states)) == 0
    return last(first(states))
end

function iterate_monad!(states, f, part)
    next_states = Tuple{Int, Int}[]
    sizehint!(next_states, 9 * length(states))
    for (z, n) in states
        for w in 1:9
            push!(next_states, (f(w, z)::Int, 10 * n + w))
        end
    end
    sort!(next_states, by = first)
    empty!(states)
    sizehint!(states, length(next_states))
    last_z = first(first(next_states)) - 1
    last_n = 0
    for (z, n) in next_states
        if z != last_z
            push!(states, (z, n))
            last_z = z
            last_n = n
        elseif (part == 1 && n > last_n) || (part == 2 && n < last_n)
            states[end] = (z, n)
            last_n = n
        end
    end
end

part1(input) = run_monad(1)
part2(input) = run_monad(2)
