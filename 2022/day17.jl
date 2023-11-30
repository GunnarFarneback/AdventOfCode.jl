const raw_shapes = [[(0, 0), (1, 0), (2, 0), (3, 0)],
                    [(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)],
                    [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
                    [(0, 0), (0, 1), (0, 2), (0, 3)],
                    [(0, 0), (1, 0), (0, 1), (1, 1)]]

function part1(input)
    jets = Int.(input.data[1:(end - 1)] .- 61)
    shapes = raw_shapes
    widths = [4, 3, 3, 1, 2]
    m = zeros(Int, 2022 * 4 + 1, 7)
    m[1, :] .= 1
    i = 1
    y_max = 2
    for b = 1:2022
        shape = shapes[mod1(b, 5)]
        width = widths[mod1(b, 5)]
        x = 3
        y = y_max
        for _ in 1:4
            x = clamp(x + jets[i], 1, 8 - width)
            i += 1
            if i > length(jets)
                i = 1
            end
        end
        settled = false
        while true
            for (x1, y1) in shape
                if m[y + y1 - 1, x1 + x] == 1
                    for (x2, y2) in shape
                        m[y + y2, x + x2] = 1
                    end
                    y += shape[end][2] + 1
                    y_max = max(y_max, y)
                    settled = true
                    break
                end
            end
            settled && break
            y -= 1
            dx = jets[i]
            i += 1
            if i > length(jets)
                i = 1
            end
            for (x1, y1) in shape
                if !(1 <= x1 + x + dx <= 7) || m[y + y1, x1 + x + dx] == 1
                    dx = 0
                    break
                end
            end
            x += dx
        end
    end
    return y_max - 2
end


function part2(input)
    jets = Int.(input.data[1:(end - 1)] .- 61)
    shapes = raw_shapes
    widths = [4, 3, 3, 1, 2]
    m = zeros(Int, 1000 * 2022 * 4 + 1, 7)
    m[1, :] .= 1
    i = 1
    y_max = 2
    states = Tuple{Matrix{Int}, Int, Int}[]
    heights = Int[]
    for b = 1:10000000
        shape = shapes[mod1(b, 5)]
        width = widths[mod1(b, 5)]
        x = 3
        y = y_max
        for _ in 1:4
            x = clamp(x + jets[i], 1, 8 - width)
            i += 1
            if i > length(jets)
                i = 1
            end
        end
        settled = false
        while true
            for (x1, y1) in shape
                if m[y + y1 - 1, x1 + x] == 1
                    for (x2, y2) in shape
                        m[y + y2, x + x2] = 1
                    end
                    y += shape[end][2] + 1
                    y_max = max(y_max, y)
                    settled = true
                    break
                end
            end
            settled && break
            y -= 1
            dx = jets[i]
            i += 1
            if i > length(jets)
                i = 1
            end
            for (x1, y1) in shape
                if !(1 <= x1 + x + dx <= 7) || m[y + y1, x1 + x + dx] == 1
                    dx = 0
                    break
                end
            end
            x += dx
        end
        push!(heights, y_max - 2)

        depth = maximum(findfirst(==(1), m[y_max:-1:1, j]) for j = 1:7)

        m1 = m[(y_max - depth + 1):y_max, :]
        state = (m1, mod(b, 5), mod(i, length(jets)))
        if state in states
            k = only(findall(states .== Ref(state)))
            cycle_length = length(heights) - k
            a, b = divrem(10^12 - length(heights), cycle_length)
            return a * (heights[end] - heights[k]) + heights[end] + heights[b + k] - heights[k]
        end
        push!(states, state)
        @assert y_max < size(m, 1) - 10
    end
end
