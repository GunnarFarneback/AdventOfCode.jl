part1(input) = repeated_look_and_say(input, 40)
part2(input) = repeated_look_and_say(input, 50)

function repeated_look_and_say(input, n)
    x = parse.(Int, collect(readchomp(input)))
    for i = 1:n
        x = look_and_say(x)
    end
    return length(x)
end

function look_and_say(x)
    y = Int[]
    last_d = first(x)
    run_length = 0
    for d in x
        if d == last_d
            run_length += 1
        else
            if last_d > 0
                push!(y, run_length, last_d)
            end
            run_length = 1
            last_d = d
        end
    end
    push!(y, run_length, last_d)
end
