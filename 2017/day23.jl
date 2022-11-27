function part1(input)
    program = split.(readlines(input), " ")
    return first(run(program, Dict{String, Int}()))
end

function part2(input)
    program = split.(optimize(readchomp(input)), " ")
    return last(run(program, Dict("a" => 1)))
end

function run(program, registers)
    pc = 1
    num_mul = 0
    while true
        op, a, b = program[pc]
        if op == "set"
            registers[a] = get_value(registers, b)
        elseif op == "sub"
            registers[a] = get(registers, a, 0) - get_value(registers, b)
        elseif op == "mul"
            registers[a] = get(registers, a, 0) * get_value(registers, b)
            num_mul += 1
        elseif op == "jnz"
            if get_value(registers, a) != 0
                pc += get_value(registers, b) - 1
            end
        elseif op == "isprime"
            if isprime(get(registers, a, 0))
                registers[a] = get_value(registers, b)
            end
        elseif op != "nop"
            @assert false
        end
        pc += 1
        if pc < 1 || pc > length(program)
            break
        end
    end
    return num_mul, get(registers, "h", 0)
end

function isprime(n)
    for i in 2:isqrt(n)
        mod(n, i) == 0 && return false
    end
    return true
end

function get_value(registers, x)
    y = tryparse(Int, x)
    if isnothing(y)
        return get(registers, x, 0)
    else
        return y
    end
end

function optimize(program_text)
    from = """
           set d 2
           set e 2
           set g d
           mul g e
           sub g b
           jnz g 2
           set f 0
           sub e -1
           set g e
           sub g b
           jnz g -8
           sub d -1
           set g d
           sub g b
           jnz g -13
           """
    to = """
         set g b
         isprime g 0
         jnz g 2
         jnz 1 2
         set f 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         nop 0 0
         """
    return split(replace(program_text, from => to), "\n")
end
