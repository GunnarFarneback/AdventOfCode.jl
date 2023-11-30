struct Monkey
    start::Vector{Int}
    operation::Symbol
    param::Int
    test::Base.MultiplicativeInverses.SignedMultiplicativeInverse{Int}
    to_true::Int
    to_false::Int
end

function part1(input)
    monkeys = parse_input(input)
    return monkey_business(monkeys, 20, 3)
end

function part2(input)
    monkeys = parse_input(input)
    M = Base.MultiplicativeInverses.multiplicativeinverse(prod(monkey.test.divisor for monkey in monkeys))
    return monkey_business(monkeys, 10000, M)
end

function parse_input(input)
    monkeys = Monkey[]
    start = Int[]
    operation = (:nothing, 0)
    param = -1
    test = 0
    to_true = to_false = 0
    for line in eachline(input)
        if startswith(line, "  Starting")
            start = parse.(Int, split(line[19:end], ", "))
        elseif startswith(line, "  Operation")
            rhs = line[20:end]
            if rhs == "old * old"
                operation = :square
                param = -1
            elseif startswith(rhs, "old *")
                operation = :*
                param = parse(Int, rhs[7:end])
            elseif startswith(rhs, "old +")
                operation = :+
                param = parse(Int, rhs[7:end])
            end
        elseif startswith(line, "  Test")
            test = parse(Int, line[22:end])
        elseif startswith(line, "    If true")
            to_true = 1 + parse(Int, line[30:end])
        elseif startswith(line, "    If false")
            to_false = 1 + parse(Int, line[31:end])
            push!(monkeys, Monkey(start, operation, param,
                                  Base.MultiplicativeInverses.multiplicativeinverse(test),
                                  to_true, to_false))
        end
    end
    return monkeys
end

function monkey_business(monkeys, num_iterations, M)
    activity = fill(0, length(monkeys))
    for (m, monkey) in enumerate(monkeys)
        for item in monkey.start
            iteration = 1
            i = m
            while iteration <= num_iterations
                (; operation, param, test, to_true, to_false) = monkeys[i]
                activity[i] += 1
                if operation == :square
                    item = item * item
                elseif operation == :*
                    item *= param
                elseif operation == :+
                    item += param
                end
                if M isa Int
                    item ÷= 3
                else
                    item %= M
                end
                if item % test == 0
                    iteration += to_true < i
                    i = to_true
                else
                    iteration += to_false < i
                    i = to_false
                end
            end
        end
    end
    return prod(sort(activity, rev = true)[1:2])
end
