using UnicodePlots: heatmap

function part1(input)
    x = 1
    X = [x]
    for instruction in eachline(input)
        if instruction == "noop"
            push!(X, x)
        else
            push!(X, x)
            push!(X, x)
            x += parse(Int, instruction[6:end])
        end
    end
    return sum(i * X[i + 1] for i in 20:40:220)
end

function part2(input)
    x = 1
    X = [x]
    for instruction in eachline(input)
        if instruction == "noop"
            push!(X, x)
        else
            push!(X, x)
            push!(X, x)
            x += parse(Int, instruction[6:end])
        end
    end
    X = X[2:end]
    Y = permutedims(reshape(abs.(mod1.(1:length(X), 40) .- X .- 1) .<= 1, 40, 6))
    heatmap(reverse(Y, dims = 1))
end
