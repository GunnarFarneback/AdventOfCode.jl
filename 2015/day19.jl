function part1(input)
    rules, medicine = parse_input(input)
    return length(transform(rules, medicine))
end

function part2(input)
    rules, medicine = parse_input(input)
    rules = reverse.(rules)
    immediate_rules = filter(p -> occursin("Ca", first(p)), rules)
    filter!(p -> !occursin("Ca", first(p)), rules)
    append!(immediate_rules, filter(p -> occursin("TiTi", first(p)), rules))
    filter!(p -> !occursin("TiTi", first(p)), rules)
    RnAr = filter(r -> endswith(r, "Ar"), first.(rules))
    RnAr = unique([r[first(findfirst("Rn", r)):end] for r in RnAr])
    i = 1
    molecules = Dict(medicine => 0)
    queue = [medicine]
    depth = 0
    while !isempty(queue)
        molecule = popfirst!(queue)
        if molecules[molecule] > depth
            depth = molecules[molecule]
        end
        new_molecules = transform_one(immediate_rules, molecule)
        if isempty(new_molecules)
            new_molecules = transform_reduced(rules, RnAr, molecule)
        end
        for new_molecule in new_molecules
            new_molecule == "e" && return molecules[molecule] + 1
            if !haskey(molecules, new_molecule)
                molecules[new_molecule] = molecules[molecule] + 1
                push!(queue, new_molecule)
            end
        end
    end
end

function parse_input(input)
    rules = Tuple{String, String}[]
    for line in eachline(input)
        if occursin(" => ", line)
            push!(rules, Tuple(string.(split(line, " => "))))
        elseif !isempty(line)
            return rules, line
        end
    end
end

function transform(rules, molecule)
    products = Set{String}()
    for (a, b) in rules
        n = length(a) - 1
        for i = 1:(length(molecule) - n)
            if molecule[i:(i + n)] == a
                push!(products, join([molecule[1:(i - 1)], b, molecule[(i + n + 1):end]]))
            end
        end
    end
    return products
end

function transform_one(rules, molecule)
    for (a, b) in rules
        n = length(a) - 1
        for i = 1:(length(molecule) - n)
            if molecule[i:(i + n)] == a
                return [join([molecule[1:(i - 1)], b, molecule[(i + n + 1):end]])]
            end
        end
    end
    return String[]
end

function transform_reduced(rules, RnAr, molecule)
    products = String[]
    if !occursin("Ar", molecule)
        start = 1
        stop = length(molecule)
    else
        stop = last(findfirst("Ar", molecule))
        Rn = findall("Rn", molecule)
        starts = filter(<(stop), first.(Rn))
        start = starts[end]
        if molecule[start:stop] ∈ RnAr
            if length(starts) < 2
                start = 1
            else
                start = starts[end - 1]
            end
        end
    end
    for (a, b) in rules
        n = length(a) - 1
        for i = start:(stop - n)
            if molecule[i:(i + n)] == a
                push!(products, join([molecule[1:(i - 1)], b, molecule[(i + n + 1):end]]))
            end
        end
    end
    return products
end
