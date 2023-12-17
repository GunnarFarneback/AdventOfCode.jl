function part1(input)
    s = 0
    h = 0x00
    for c in input.data
        if c == UInt8(',')
            s += h
            h = 0x00
        elseif c != UInt8('\n')
            h += c
            h *= UInt8(17)
        end
    end
    s += h
    return s
end

function part2(input)
    boxes = Dict(i => [] for i in 0:255)
    for instruction in split(readline(input), ",")
        label, focal_length = split(instruction, ['=', '-'])
        i = hash(label)
        if isempty(focal_length)
            box = boxes[i]
            box = filter(x -> first(x) != label, box)
            boxes[i] = box
        else
            box = boxes[i]
            j = findfirst(x -> first(x) == label, box)
            if isnothing(j)
                push!(box, (label, parse(Int, focal_length)))
            else
                box[j] = (label, parse(Int, focal_length))
            end
        end
    end
    s = 0
    for (i, box) in boxes
        for (j, (label, focal_length)) in enumerate(box)
            s += (i + 1) * j * focal_length
        end
    end
    return s
end

function hash(s)
    h = 0x00
    for c in s
        h += UInt8(c)
        h *= UInt8(17)
    end
    return Int(h)
end
