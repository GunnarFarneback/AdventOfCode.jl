function part1(input)
    food_list = parse_input(input)
    all_ingredients_with_repetition = reduce(vcat, first.(food_list))
    potential_allergen_sources = find_potential_allergen_sources(food_list)
    potential_allergens = reduce(union, values(potential_allergen_sources))
    return length(filter(x -> x ∉ potential_allergens,
                         all_ingredients_with_repetition))
end

function part2(input)
    food_list = parse_input(input)
    potential_allergen_sources = find_potential_allergen_sources(food_list)
    allergen_sources = Dict{String, String}()
    while !isempty(potential_allergen_sources)
        for (allergen, ingredients) in potential_allergen_sources
            if length(ingredients) == 1
                ingredient = only(ingredients)
                allergen_sources[allergen] = ingredient
                delete!(potential_allergen_sources, allergen)
                filter!.(!=(ingredient), values(potential_allergen_sources))
                break
            end
        end
    end
    return join((allergen_sources[allergen]
                 for allergen in sort(collect(keys(allergen_sources)))), ",")
end

function parse_input(input)
    return parse_line.(readlines(input))
end

function parse_line(line)
    ingredients, allergens = match(r"([\w ]+) \(contains ([\w ,]+)\)", line).captures
    return String.(split(ingredients, " ")), String.(split(allergens, ", "))
end

function find_potential_allergen_sources(food_list)
    potential_allergen_sources = Dict{String, Vector{String}}()
    for (ingredients, allergens) in food_list
        for allergen in allergens
            if !haskey(potential_allergen_sources, allergen)
                potential_allergen_sources[allergen] = copy(ingredients)
            else
                intersect!(potential_allergen_sources[allergen], ingredients)
            end
        end
    end
    return potential_allergen_sources
end
