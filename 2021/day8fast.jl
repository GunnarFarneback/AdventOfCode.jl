function part1(input)
    final_sum = 0
    w = 0
    analyzing = true
    for c in input.data
        if c == UInt8('|')
            analyzing = false
        elseif analyzing
            continue
        elseif c == UInt8(' ') || c == UInt8('\n')
            if 2 <= w <= 4 || w == 7
                final_sum += 1
            end
            w = 0

            if c == UInt8('\n')
                analyzing = true
            end
        else
            w += 1
        end
    end
    return final_sum
end

function part2(input)
    final_sum = 0
    current_number = 0
    wa = wb = wc = wd = we = wf = wg = 0
    w = 0
    analyzing = true
    for c in input.data
        if c == UInt8(' ') || c == UInt8('\n')
            analyzing && continue
            w == 0 && continue
            current_number *= 10
            w == 42 && (current_number += 0)
            w == 17 && (current_number += 1)
            w == 34 && (current_number += 2)
            w == 39 && (current_number += 3)
            w == 30 && (current_number += 4)
            w == 37 && (current_number += 5)
            w == 41 && (current_number += 6)
            w == 25 && (current_number += 7)
            w == 49 && (current_number += 8)
            w == 45 && (current_number += 9)
            w = 0

            if c == UInt8('\n')
                final_sum += current_number
                current_number = 0
                wa = wb = wc = wd = we = wf = wg = 0
                analyzing = true
            end
        elseif c == UInt8('a')
            analyzing ? (wa += 1) : (w += wa)
        elseif c == UInt8('b')
            analyzing ? (wb += 1) : (w += wb)
        elseif c == UInt8('c')
            analyzing ? (wc += 1) : (w += wc)
        elseif c == UInt8('d')
            analyzing ? (wd += 1) : (w += wd)
        elseif c == UInt8('e')
            analyzing ? (we += 1) : (w += we)
        elseif c == UInt8('f')
            analyzing ? (wf += 1) : (w += wf)
        elseif c == UInt8('g')
            analyzing ? (wg += 1) : (w += wg)
        elseif c == UInt8('|')
            analyzing = false
        end
    end
    return final_sum
end
