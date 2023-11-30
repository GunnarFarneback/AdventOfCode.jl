struct Monkey
    start::Vector{Int}
    operation::Tuple{Symbol, Int}
    test::Int
    to_true::Int
    to_false::Int
end

function part1(input)
    monkeys = parse_input(input)
    return monkey_business(monkeys, 20, x -> x ÷ 3)
end

function part2(input)
    monkeys = parse_input(input)
    M = prod(monkey.test for monkey in monkeys)
    return monkey_business(monkeys, 10000, x -> mod(x, M))
end

function parse_input(input)
    monkeys = Monkey[]
    start = Int[]
    operation = (:nothing, 0)
    test = 0
    to_true = to_false = 0
    for line in eachline(input)
        if startswith(line, "  Starting")
            start = parse.(Int, split(line[19:end], ", "))
        elseif startswith(line, "  Operation")
            rhs = line[20:end]
            if rhs == "old * old"
                operation = (:square, -1)
            elseif startswith(rhs, "old *")
                operation = (:*, parse(Int, rhs[7:end]))
            elseif startswith(rhs, "old +")
                operation = (:+, parse(Int, rhs[7:end]))
            end
        elseif startswith(line, "  Test")
            test = parse(Int, line[22:end])
        elseif startswith(line, "    If true")
            to_true = 1 + parse(Int, line[30:end])
        elseif startswith(line, "    If false")
            to_false = 1 + parse(Int, line[31:end])
            push!(monkeys, Monkey(start, operation, test, to_true, to_false))
        end
    end
    return monkeys
end

function monkey_business(monkeys, num_iterations, worry_management)
    all_items = [monkey.start for monkey in monkeys]
    activity = fill(0, length(monkeys))
    for _ in 1:num_iterations
        for (m, monkey) in enumerate(monkeys)
            items = all_items[m]
            activity[m] += length(items)
            operation = monkey.operation
            if operation[1] == :square
                items .= items .* items
            elseif operation[1] == :*
                items .*= operation[2]
            elseif operation[1] == :+
                items .+= operation[2]
            end
            items .= worry_management.(items)
            while !isempty(items)
                item = pop!(items)
                if mod(item, monkey.test) == 0
                    push!(all_items[monkey.to_true], item)
                else
                    push!(all_items[monkey.to_false], item)
                end
            end
        end
    end
    return prod(sort(activity, rev = true)[1:2])
end
