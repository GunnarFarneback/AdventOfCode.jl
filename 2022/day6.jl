function part1(input)
    x = read(input)
    for i = 4:length(x)
        if length(unique(x[(i - 3):i])) == 4
            return i
        end
    end
end

function part2(input)
    x = read(input)
    for i = 14:length(x)
        if length(unique(x[(i - 13):i])) == 14
            return i
        end
    end
end
