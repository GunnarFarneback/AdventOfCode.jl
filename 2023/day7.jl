function part1(input)
    data = [split(line) .|> [remap_cards1, x -> parse(Int, x)]
            for line in eachline(input)]
    sum(last.(sort(data, by = power1)) .* (1:length(data)))    
end

remap_cards1(card) = replace(card, (collect("TJQKA") .=> collect("abcde"))...)

function power1(hand_and_bid)
    hand = first(hand_and_bid)
    power = sort([count(==(card), collect(hand))
                  for card in unique(hand)], rev = true)
    return power, hand
end

function part2(input)
    data = [split(line) .|> [remap_cards2, x -> parse(Int, x)]
            for line in eachline(input)]
    sum(last.(sort(data, by = power2)) .* (1:length(data)))    
end

remap_cards2(card) = replace(card, (collect("TJQKA") .=> collect("a1cde"))...)

function power2(hand_and_bid)
    hand = first(hand_and_bid)
    power = sort([count(==(card), collect(hand))
                  for card in unique(replace(hand, "1" => ""))], rev = true)
    if isempty(power)
        power = [5]
    else
        power[1] += 5 - sum(power)
    end
    return power, hand
end
