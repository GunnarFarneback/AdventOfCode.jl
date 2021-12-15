part1(input) = compute(input, 10)
part2(input) = compute(input, 40)

function compute(input, num_iterations)
    n, state, table1, table2, first = parse_input(input)
    state2 = Vector{Int}(undef, n^2)
    for i = 1:num_iterations
        iterate!(state, state2, table1, table2)
        state, state2 = state2, state
    end
    k = 1
    freq = zeros(Int, n)
    freq[first + 1] = 1
    for i = 1:n, j = 1:n
        freq[j] += state[k]
        k += 1
    end
    a, b = extrema(freq)
    return b - a
end

function parse_input(input)
    char_mapping = fill(0xFF, 256)
    n = 0
    i = 0
    data = input.data
    while true
        i += 1
        c = data[i]
        c == UInt8('\n') && break
        if char_mapping[c] == 0xFF
            char_mapping[c] = n
            n += 1
        end
    end
    initial_state = zeros(Int, n^2)
    for j = 2:i-1
        a = char_mapping[data[j - 1]]
        b = char_mapping[data[j]]
        initial_state[n * a + b + 1] += 1
    end
    i += 2
    table1 = zeros(UInt8, n^2)
    table2 = zeros(UInt8, n^2)
    while i < length(data)
        a = char_mapping[data[i]]
        b = char_mapping[data[i + 1]]
        c = char_mapping[data[i + 6]]
        table1[n * a + b + 1] = n * a + c + 1
        table2[n * a + b + 1] = n * c + b + 1
        i += 8
    end
    first = char_mapping[data[1]]
    return n, initial_state, table1, table2, first
end

function iterate!(state, state2, table1, table2)
    fill!(state2, 0)
    for (i, n) in enumerate(state)
        state2[table1[i]] += n
        state2[table2[i]] += n
    end
end
