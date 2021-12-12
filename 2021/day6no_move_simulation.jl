part1(input) = simulate(input, 80)
part2(input) = simulate(input, 256)

function simulate(input, steps)
    x0 = x1 = x2 = x3 = x4 = x5 = x6 = x7 = x8 = 0
    for c in read(input)[1:2:end]
        if c == UInt8('1')
            x1 += 1
        elseif c == UInt8('2')
            x2 += 1
        elseif c == UInt8('3')
            x3 += 1
        elseif c == UInt8('4')
            x4 += 1
        elseif c == UInt8('5')
            x5 += 1
        end
    end
    while true
        x7 += x0; (steps -= 1) > 0 || break
        x8 += x1; (steps -= 1) > 0 || break
        x0 += x2; (steps -= 1) > 0 || break
        x1 += x3; (steps -= 1) > 0 || break
        x2 += x4; (steps -= 1) > 0 || break
        x3 += x5; (steps -= 1) > 0 || break
        x4 += x6; (steps -= 1) > 0 || break
        x5 += x7; (steps -= 1) > 0 || break
        x6 += x8; (steps -= 1) > 0 || break
    end
    return x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8
end
