using Images: mapwindow, Fill

function part1(input)
    lut, image = parse_input(input)
    return sum(enhance(image, lut, 2))
end

function part2(input)
    lut, image = parse_input(input)
    return sum(enhance(image, lut, 50))
end

function parse_input(input)
    parts = split(readchomp(input), "\n\n")
    lut = collect(first(parts)) .== '#'
    image = reduce(hcat, (x -> Int.(collect(x) .== '#')).(split(last(parts), "\n")))
    return lut, image
end

function enhance(image, lut, n)
    for i = 1:n
        border = first(lut) & ((i + 1) % 2)
        padded_image = fill(border, size(image) .+ 2)
        padded_image[2:end-1, 2:end-1] .= image
        image = mapwindow(padded_image, (3, 3), border = Fill(border)) do x
            lut[1 + sum((1 .<< (8:-1:0)) .* vec(x))]
        end
    end
    return image
end
