using UnicodePlots

function part1(input)
    return count(simulate_display(input))
end

function part2(input)
    display = simulate_display(input)
    return heatmap(display[end:-1:1, :])
end

function simulate_display(input)
    display = fill(false, 6, 50)
    for instruction in eachline(input)
        if startswith(instruction, "rect")
            width, height = parse.(Int, split(last(split(instruction, " ")), "x"))
            display[1:height, 1:width] .= true
        else
            i, n = parse.(Int, split(last(split(instruction, "=")), " by "))
            if occursin("column", instruction)
                display[:, i + 1] .= display[mod1.((1:end) .- n, end), i + 1]
            else
                display[i + 1, :] .= display[i + 1, mod1.((1:end) .- n, end)]
            end
        end
    end
    return display
end
