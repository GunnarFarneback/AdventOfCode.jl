function part1(input)
    bingo = parse_input(input)
    winner, last_number = play!(bingo, true)
    return last_number * sum(line.sum_left for line in winner.lines[1:5])
end

function part2(input)
    bingo = parse_input(input)
    last_winner, last_number = play!(bingo, false)
    return last_number * sum(line.sum_left for line in last_winner.lines[1:5])
end

mutable struct Line
    sum_left::Int
    num_left::Int
    board::Int
end

struct Board
    lines::Vector{Line}
end

struct Bingo
    numbers::Vector{Int}
    boards::Vector{Board}
    affected_lines::Dict{Int, Vector{Line}}
end

function parse_input(input)
    parts = split(readchomp(input), "\n\n")
    numbers = parse.(Int, split(first(parts), ","))
    affected_lines = Dict{Int, Vector{Line}}()
    boards = Board[]
    for i = 2:length(parts)
        part = parts[i]
        push!(boards, parse_board(i - 1, part, affected_lines))
    end
    return Bingo(numbers, boards, affected_lines)
end

function parse_board(n, board, affected_lines)
    board = reshape(parse.(Int, split(board)), 5, 5)
    lines = Line[]
    for line_numbers in vcat(collect(eachrow(board)), collect(eachcol(board)))
        line = Line(sum(line_numbers), length(line_numbers), n)
        push!(lines, line)
        for number in line_numbers
            push!(get!(affected_lines, number, Line[]), line)
        end
    end
    return Board(lines)
end

function play!(bingo, win)
    winners = Int[]
    for number in bingo.numbers
        for line in bingo.affected_lines[number]
            line.sum_left -= number
            line.num_left -= 1
            if line.num_left == 0
                union!(winners, line.board)
            end
        end
        if win && !isempty(winners)
            return bingo.boards[only(winners)], number
        end
        if !win && length(winners) == length(bingo.boards)
            return bingo.boards[last(winners)], number
        end
    end
    @assert false
end
