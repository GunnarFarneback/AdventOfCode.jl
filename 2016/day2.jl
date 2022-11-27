function part1(input)
    i, j = 2, 2
    code = 0
    for line in eachline(input)
        for letter in line
            if letter == 'L'
                j = max(1, j - 1)
            elseif letter == 'R'
                j = min(3, j + 1)
            elseif letter == 'U'
                i = max(1, i - 1)
            elseif letter == 'D'
                i = min(3, i + 1)
            end
        end
        code = 10 * code + (i - 1) * 3 + j
    end
    return code
end

function part2(input)
    i, j = 3, 1
    code = ""
    for line in eachline(input)
        for letter in line
            if letter == 'L'
                j = max(1 + abs(i - 3), j - 1)
            elseif letter == 'R'
                j = min(5 - abs(i - 3), j + 1)
            elseif letter == 'U'
                i = max(1 + abs(j - 3), i - 1)
            elseif letter == 'D'
                i = min(5 - abs(j - 3), i + 1)
            end
        end
        code *= uppercase(string([0  0  1  0 0
                                  0  2  3  4 0
                                  5  6  7  8 9
                                  0 10 11 12 0
                                  0  0 13  0 0][i, j], base = 16))
    end
    return code
end
