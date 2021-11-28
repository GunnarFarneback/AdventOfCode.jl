function part1(input)
    rules, messages = parse_input(input)
    regexp = Regex("^" * expand_rule(rules, "0") * "\$")
    count(message -> occursin(regexp, message), messages)
end

function part2(input)
    rules, messages = parse_input(input)
    haskey(rules, "42") || return nothing
    r42 = expand_rule(rules, "42")
    r31 = expand_rule(rules, "31")
    regexp = Regex("^(($(r42))+)(($(r31))+)\$")
    num_good_messages = 0
    for message in messages
        occursin(regexp, message) || continue
        m = match(regexp, message)
        a = m.captures[1]
        b = m.captures[findfirst(==(1 + length(a)), m.offsets)]
        @assert a * b == message
        num_42_repetitions = 0
        while occursin(Regex("($(r42)){$(num_42_repetitions + 1)}"), a)
            num_42_repetitions += 1
        end
        num_31_repetitions = 0
        while occursin(Regex("($(r31)){$(num_31_repetitions + 1)}"), b)
            num_31_repetitions += 1
        end
        if num_42_repetitions > num_31_repetitions
            num_good_messages += 1
        end
    end
    return num_good_messages
end

struct InputRule
    rule::String
end

function parse_input(input)
    raw_rules, messages = split.(split(read(input, String), "\n\n"), "\n")
    rules = Dict{String, Any}(Pair(String(id), InputRule(rule))
                 for (id, rule) in split.(raw_rules, ": "))
    return rules, messages
end

expand_rule(rules, id::String) = expand_rule(rules, id, rules[id])
expand_rule(rules, id::String, rule::String) = rule

function expand_rule(rules, id::String, rule::InputRule)
    match1 = match(r"\"(.)\"", rule.rule)
    if !isnothing(match1)
        rules[id] = String(only(match1.captures))
    elseif contains(rule.rule, "|")
        parts = InputRule.(split(rule.rule, " | "))
        rules[id] = "(" * join((string("(", expand_rule(rules, "", part), ")")
                                for part in parts), "|") * ")"
        return rules[id]
    else
        parts = split(rule.rule, " ")
        rules[id] = join((expand_rule(rules, String(part))
                          for part in parts), "")
    end
    return rules[id]
end
