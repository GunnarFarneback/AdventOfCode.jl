function part1(input)
    expenses = falses(2021)
    for expense_string in readlines(input)
        expense = parse(Int, expense_string)
        if expenses[1 + 2020 - expense]
            return expense * (2020 - expense)
        end
        expenses[1 + expense] = true
    end
    error("No solution found.")
end

function part2(input)
    expenses = Int[]
    two_expenses = Dict{Int, Int}()
    for expense_string in readlines(input)
        expense = parse(Int, expense_string)
        if haskey(two_expenses, 2020 - expense)
            return two_expenses[2020 - expense] * expense
        end
        for expense2 in expenses
            two_expenses[expense + expense2] = expense * expense2
        end
        push!(expenses, expense)
    end
    error("No solution found.")
end
