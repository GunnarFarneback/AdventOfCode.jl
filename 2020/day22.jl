function part1(input)
    deck1, deck2 = parse_input(input)
    play_combat!(deck1, deck2)
    return max(score_deck(deck1), score_deck(deck2))
end

function part2(input)
    deck1, deck2 = parse_input(input)
    winner = play_recursive_combat!(deck1, deck2)
    return score_deck((deck1, deck2)[winner])
end

function parse_input(input)
    return parse_deck.(split(readchomp(input), "\n\n"))
end

function parse_deck(deck)
    return parse.(Int, split(deck, "\n")[2:end])
end

function play_combat!(deck1, deck2)
    while !isempty(deck1) && !isempty(deck2)
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)
        if card1 > card2
            push!(deck1, card1, card2)
        else
            push!(deck2, card2, card1)
        end
    end
end

function play_recursive_combat!(deck1, deck2)
    played_states = Set{Tuple{Vector{Int}, Vector{Int}}}()
    while true
        isempty(deck1) && return 2
        isempty(deck2) && return 1
        (deck1, deck2) in played_states && return 1
        push!(played_states, (copy(deck1), copy(deck2)))
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)
        if card1 <= length(deck1) && card2 <= length(deck2)
            winner = play_recursive_combat!(deck1[1:card1], deck2[1:card2])
        else
            winner = card1 > card2 ? 1 : 2
        end
        if winner == 1
            push!(deck1, card1, card2)
        else
            push!(deck2, card2, card1)
        end
    end
end

function score_deck(deck)
    return sum(reverse(deck) .* (1:length(deck)))
end
