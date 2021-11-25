function part1(input)
    instructions = readlines(input)
    state = State1(0, 0, "E")
    for instruction in instructions
        move!(state, instruction)
    end
    return abs(state.x) + abs(state.y)
end

mutable struct State1
    x::Int
    y::Int
    heading::String
end

function move!(state::State1, instruction)
    action = instruction[1:1]
    value = parse(Int, instruction[2:end])
    move!(state, action, value)
end

function move!(state::State1, action, value)
    if action == "S"
        state.y -= value
    elseif action == "N"
        state.y += value
    elseif action == "W"
        state.x -= value
    elseif action == "E"
        state.x += value
    elseif action == "R"
        @assert mod(value, 90) == 0
        value < 0 && move!(state, "L", value)
        while value > 0
            state.heading = Dict("E" => "S", "S" => "W",
                                 "W" => "N", "N" => "E")[state.heading]
            value -= 90
        end
    elseif action == "L"
        @assert mod(value, 90) == 0
        value < 0 && move!(state, "R", value)
        while value > 0
            state.heading = Dict("E" => "N", "N" => "W",
                                 "W" => "S", "S" => "E")[state.heading]
            value -= 90
        end
    elseif action == "F"
        move!(state, state.heading, value)
    end
end

function part2(input)
    instructions = readlines(input)
    state = State2([0, 0], [10, 1])
    for instruction in instructions
        move!(state, instruction)
    end
    return sum(abs.(state.position))
end

mutable struct State2
    position::Vector{Int}
    waypoint::Vector{Int}
end

function move!(state::State2, instruction)
    action = instruction[1:1]
    value = parse(Int, instruction[2:end])
    move!(state, action, value)
end

function move!(state::State2, action, value)
    if action == "S"
        state.waypoint .+= [0, -value]
    elseif action == "N"
        state.waypoint .+= [0, value]
    elseif action == "W"
        state.waypoint .+= [-value, 0]
    elseif action == "E"
        state.waypoint .+= [value, 0]
    elseif action == "R"
        @assert mod(value, 90) == 0
        value < 0 && move!(state, "L", value)
        while value > 0
            state.waypoint = [0 1;-1 0] * state.waypoint
            value -= 90
        end
    elseif action == "L"
        @assert mod(value, 90) == 0
        value < 0 && move!(state, "R", value)
        while value > 0
            state.waypoint = [0 -1;1 0] * state.waypoint
            value -= 90
        end
    elseif action == "F"
        state.position += value .* state.waypoint
    end
end
