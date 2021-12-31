function part1(input)
    board, position = parse_input(input, part = 1)
    return play(board, position, UInt8.(max.(board.area, 0)))
end

function part2(input)
    board, position = parse_input(input, part = 2)
    return play(board, position, UInt8.(max.(board.area, 0)))
end

struct Board
    area::Vector{Int}
    distances::Matrix{Int}
    moves::Vector{Vector{Vector{Int}}}
end

function parse_input(input; part)
    raw_board = collect.(readlines(input))
    if part == 2
        insert!(raw_board, 4, collect("  #D#C#B#A#"))
        insert!(raw_board, 5, collect("  #D#B#A#C#"))
    end
    
    n = 2 * part
    area = vcat(0, 0, -1, 0, -1, 0, -1, 0, -1, 0, 0,
                fill(1, n), fill(2, n), fill(3, n), fill(4, n))
    neighbors = [[2],
                 [1, 3],
                 [2, 4, 12],
                 [3, 5],
                 [4, 6, 12 + n],
                 [5, 7],
                 [6, 8, 12 + 2 * n],
                 [7, 9],
                 [8, 10, 12 + 3 * n],
                 [9, 11],
                 [10]]
    for i = 1:4
        for j = 1:n
            j == 1 && push!(neighbors, [1 + 2 * i, 13 + n * (i - 1)])
            1 < j < n && push!(neighbors, [10 + n * (i - 1) + j, 12 + n * (i - 1) + j])
            j == n && push!(neighbors, [10 + n * (i - 1) + j])
        end
    end

    N = length(area)
    distances = zeros(Int, N, N)
    moves = Vector{Vector{Int}}[]
    for i = 1:length(area)
        if area[i] < 0
            push!(moves, Int[])
            continue
        end
        visited = falses(N)
        dist = zeros(N)
        push!(moves, Vector{Int}[])
        dfs!(area, neighbors, visited, Int[], dist, moves[i], i, 0)
        if area[i] == 0
            filter!(x -> area[last(x)] > 0, moves[i])
        else
            filter!(x -> area[last(x)] != area[first(x)], moves[i])
        end
        distances[i, :] .= dist
    end

    position = vcat(zeros(UInt8, 11))
    for i = 1:4
        for j = 1:n
            push!(position, 1 + raw_board[2 + j][2 + 2 * i] - UInt8('A'))
        end
    end

    return Board(area, distances, moves), position
end

function dfs!(area, neighbors, visited, path, dist, moves, vertex, depth)
    visited[vertex] = true
    dist[vertex] = depth
    if depth > 0
        push!(path, vertex)
        if area[vertex] >= 0
            push!(moves, copy(path))
        end
    end
    for neighbor in neighbors[vertex]
        if !visited[neighbor]
            dfs!(area, neighbors, visited, path, dist, moves, neighbor, depth + 1)
        end
    end
    if depth > 0
        pop!(path)
    end
end

mutable struct PriorityQueue
    queue::Dict{Int, Vector{Vector{UInt8}}}
    min_cost::Int
end

PriorityQueue() = PriorityQueue(Dict{Int, Vector{Vector{UInt8}}}(), 0)

Base.isempty(queue::PriorityQueue) = isempty(queue.queue)

function Base.push!(queue::PriorityQueue, item, cost)
    @assert cost >= queue.min_cost
    push!(get!(() -> Vector{UInt8}[], queue.queue, cost), item)
end

function Base.pop!(queue::PriorityQueue)
    while !haskey(queue.queue, queue.min_cost) || isempty(queue.queue[queue.min_cost])
        if haskey(queue.queue, queue.min_cost)
            delete!(queue.queue, queue.min_cost)
        end
        queue.min_cost += 1
    end
    return pop!(queue.queue[queue.min_cost])
end

function play(board, position, goal)
    costs = Dict(copy(position) => 0)
    queue = PriorityQueue()
    push!(queue, position, 0)
    best_cost = typemax(Int)
    while !isempty(queue)
        position = pop!(queue)
        if costs[position] < queue.min_cost
            continue
        end
        if position == goal
            return costs[position]
        end
        for i in 1:length(position)
            color = position[i]
            color == 0 && continue
            for move in board.moves[i]
                destination = last(move)
                board.area[destination] ∉ (0, color) && continue
                any(position[j] != 0 for j in move) && continue
                if board.area[destination] > 0
                    if !valid_destination(board, position, destination, color)
                        continue
                    end
                end
                new_position = copy(position)
                new_position[i] = 0
                new_position[destination] = color
                cost = costs[position] + move_cost(color, board.distances[i, destination])
                cost > best_cost && continue
                if new_position == goal
                    best_cost = min(cost, best_cost)
                end
                if !haskey(costs, new_position)
                    costs[new_position] = cost
                    if cost < best_cost || new_position == goal
                        push!(queue, new_position, cost)
                    end
                else
                    if cost < costs[new_position]
                        costs[new_position] = cost
                        push!(queue, new_position, cost)
                    end
                end
            end
        end
    end
end

move_cost(color, distance) = 10^(color - 1) * distance

function valid_destination(board, position, destination, color)
    while true
        destination += 1
        if destination > length(board.area) || board.area[destination] != color
            return true
        end
        if position[destination] != color
            return false
        end
    end
end
