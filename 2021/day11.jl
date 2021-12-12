part1(input) = flash(input, part = 1)
part2(input) = flash(input, part = 2)

function flash(input; part)
    octopi = reduce(hcat, (parse.(Int, collect(line))
                           for line in eachline(input)))
    num_flashes = 0
    i = 0
    while true
        i += 1
        octopi .+= 1
        while true
            flashes = octopi .> 9
            (n = count(flashes)) == 0 && break
            num_flashes += n
            for Δi in -1:1, Δj in -1:1
                Δi == Δj == 0 && continue
                octopi[max(1 + Δi, 1):min(end + Δi, end),
                       max(1 + Δj, 1):min(end + Δj, end)] .+=
                    flashes[max(1 - Δi, 1):min(end - Δi, end),
                            max(1 - Δj, 1):min(end - Δj, end)]
            end
            octopi[flashes] .= -10
        end
        part == 1 && i == 100 && return num_flashes
        octopi .= max.(0, octopi)
        part == 2 && all(==(0), octopi) && return i
    end
end
