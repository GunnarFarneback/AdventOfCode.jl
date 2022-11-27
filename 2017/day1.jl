function part1(input)
    data = read(input) .- UInt8('0')
    data[end] = data[1]
    return sum(data[i] for i in 2:length(data) if data[i] == data[i - 1])
end

function part2(input)
    data = read(input) .- UInt8('0')
    pop!(data)
    n = length(data)
    return sum(data[i]
               for i in 1:length(data)
               if data[i] == data[mod1(i + n ÷ 2, n)])
end
