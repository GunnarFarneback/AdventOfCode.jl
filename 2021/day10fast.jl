part1(input) = first(part1and2(input))
part2(input) = last(part1and2(input))

function part1and2(io)
    return check_lines(io.data)
end

const lut = Int8[-3, 0, 3, -4, 4, -1, 0, 1, 0, 0, 0, 0, 0, 0, -2, 0, 2]
const corrupted_scores = [25137, 1197, 57, 3]

function check_lines(data)
    prevs = Vector{UInt16}(undef, length(data))
    last_opener = 0
    i = 1
    score1 = 0
    scores2 = Int[]
    while i <= length(data)
        c = lut[data[i] % 18]
        if c < 0
            prevs[i] = last_opener | ((-(c + 1)) << 14)
            last_opener = i
        elseif c > 0
            x = prevs[last_opener]
            if x >> 14 != c - 1
                score1 += corrupted_scores[c]
                while data[i] != UInt8('\n')
                    i += 1
                end
                last_opener = 0
            else
                last_opener = x & 0x3FFF
            end
        else
            score2 = 0
            while last_opener != 0
                x = prevs[last_opener]
                score2 = 5 * score2 + 4 - (x >> 14)
                last_opener = x & 0x3FFF
            end
            push!(scores2, score2)
        end
        i += 1
    end
    return score1, partialsort!(scores2, 1 + length(scores2) ÷ 2)
end
