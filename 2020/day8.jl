function part1(input)
    program = parse_program(input)
    accumulator, halts = run_program(program)
    @assert !halts
    return accumulator
end

function part2(input)
    program = parse_program(input)
    for i = 1:length(program)
        opcode = program[i].opcode
        if opcode == :nop
            program[i].opcode = :jmp
        elseif opcode == :jmp
            program[i].opcode = :nop
        else
            continue
        end
        accumulator, halts = run_program(program)
        halts && return accumulator
        program[i].opcode = opcode
    end
end

mutable struct Instruction
    opcode::Symbol
    value::Int
end

function parse_program(input)
    program = Instruction[]
    for line in readlines(input)
        name, value = split(line, " ")
        push!(program, Instruction(Symbol(name), parse(Int, value)))
    end
    return program
end

function run_program(program)
    accumulator = 0
    program_counter = 1
    visited_instructions = Set{Int}()
    while true
        program_counter == length(program) + 1 && return accumulator, true
        program_counter in visited_instructions && return accumulator, false
        push!(visited_instructions, program_counter)
        instruction = program[program_counter]
        if instruction.opcode == :acc
            accumulator += instruction.value
            program_counter += 1
        elseif instruction.opcode == :jmp
            program_counter += instruction.value
        elseif instruction.opcode == :nop
            program_counter += 1            
        end
    end
end    
