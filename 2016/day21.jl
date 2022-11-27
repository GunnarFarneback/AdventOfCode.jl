function part1(input)
    instructions = parse_line.(eachline(input))
    return scramble("abcdefgh", instructions)
end

function part2(input)
    instructions = parse_line.(eachline(input))
    reverse_instructions = reverse(reverse_instruction.(instructions))
    return scramble("fbgdceah", reverse_instructions)
end

function parse_line(line)
    if startswith(line, "rotate right")
        return (:rotate, parse(Int, split(line)[3]))
    elseif startswith(line, "rotate left")
        return (:rotate, -parse(Int, split(line)[3]))
    elseif startswith(line, "rotate based")
        return (:rotate_letter, only(last(split(line))))
    elseif startswith(line, "reverse")
        return (:reverse, parse.(Int, split(line)[[3, 5]]))
    elseif startswith(line, "swap position")
        return (:swap_position, parse.(Int, split(line)[[3, 6]]))
    elseif startswith(line, "swap letter")
        return (:swap_letter, only.(split(line)[[3, 6]]))
    elseif startswith(line, "move")
        return (:move, parse.(Int, split(line)[[3, 6]]))
    end
    @assert false
end

function scramble(password::String, instructions::Vector)
    letters = collect(password)
    for instruction in instructions
        letters = scramble(letters, instruction)
    end
    return join(letters)
end

function scramble(password::Vector{Char}, instruction::Tuple)
    operation, args = instruction
    if operation == :rotate
        password = circshift(password, args)
    elseif operation == :rotate_letter
        i = findfirst(==(args), password)
        i += i > 4
        password = circshift(password, i)
    elseif operation == :reverse_rotate_letter
        @assert length(password) == 8
        i = findfirst(==(args), password)
        i = Dict(2 => 7, 4 => 6, 6 => 5, 8 => 4,
                 3 => 2, 5 => 1, 7 => 0, 1 => -1)[i]
        password = circshift(password, i)
    elseif operation == :reverse
        i, j = args .+ 1
        @assert i < j
        password[i:j] .= password[j:-1:i]
    elseif operation == :swap_position
        i, j = args .+ 1
        password[i], password[j] = password[j], password[i]
    elseif operation == :swap_letter
        i = findfirst(==(args[1]), password)
        j = findfirst(==(args[2]), password)
        password[i], password[j] = password[j], password[i]
    elseif operation == :move
        i, j = args .+ 1
        c = splice!(password, i)
        splice!(password, j:j-1, c)
    end
    return password
end

function reverse_instruction(instruction)
    operation, args = instruction
    operation == :rotate && return (operation, -args)
    operation == :rotate_letter && return (:reverse_rotate_letter, args)
    operation == :move && return (operation, reverse(args))
    return instruction
end
