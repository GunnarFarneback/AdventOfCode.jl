mutable struct State
    registers::Dict{String, Int}
    pc::Int
    snd_queue::Vector{Int}
    rcv_queue::Vector{Int}
    num_send::Int
end

function part1(input)
    program = split.(readlines(input), " ")
    state = State(Dict{String, Int}(), 1, Int[], Int[], 0)
    return run(program, state; part = 1)
end

function part2(input)
    program = split.(readlines(input), " ")
    queue1 = Int[]
    queue2 = Int[]
    state1 = State(Dict("p" => 0), 1, queue1, queue2, 0)
    state2 = State(Dict("p" => 1), 1, queue2, queue1, 0)
    run(program, state1)
    while true
        isempty(state2.rcv_queue) && break
        run(program, state2)
        isempty(state1.rcv_queue) && break
        run(program, state1)
    end
    return state2.num_send
end

function run(program, state; part = 2)
    registers = state.registers
    while true
        instruction = program[state.pc]
        op = instruction[1]
        a = instruction[2]
        b = length(instruction) == 3 ? get_value(registers, instruction[3]) : 0
        if op == "snd"
            push!(state.snd_queue, get(registers, a, 0))
            state.num_send += 1
        elseif op == "set"
            registers[a] = b
        elseif op == "add"
            registers[a] = get(registers, a, 0) + b
        elseif op == "mul"
            registers[a] = get(registers, a, 0) * b
        elseif op == "mod"
            registers[a] = mod(get(registers, a, 0), b)
        elseif op == "rcv"
            if part == 1
                if get(registers, a, 0) != 0
                    return last(state.snd_queue)
                end
            else
                if isempty(state.rcv_queue)
                    return
                end
                registers[a] = popfirst!(state.rcv_queue)
            end
        elseif op == "jgz"
            if get_value(registers, a) > 0
                state.pc += b - 1
            end
        end
        state.pc += 1
    end
end

function get_value(registers, x)
    y = tryparse(Int, x)
    if isnothing(y)
        return get(registers, x, 0)
    else
        return y
    end
end
