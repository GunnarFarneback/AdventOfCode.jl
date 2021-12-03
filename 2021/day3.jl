function part1(input)
    binaries = map(line -> collect(line) .== '1', readlines(input))
    majority = sum(binaries) .> length(binaries) / 2
    γ = decode(majority)
    ϵ = decode(.!majority)
    return γ * ϵ
end

function part2(input)
    binaries = map(line -> collect(line) .== '1', readlines(input))
    oxygen = decode(find_common(copy(binaries), 1, false))
    CO2 = decode(find_common(copy(binaries), 1, true))
    return oxygen * CO2
end

decode(x) = sum(x .<< (reverse(eachindex(x)) .- 1))

function find_common(binaries, n, choose_uncommon)
    length(binaries) == 1 && return only(binaries)
    common = sum(getindex.(binaries, n)) >= length(binaries) / 2
    return find_common(filter(x -> x[n] == common ⊻ choose_uncommon, binaries),
                       n + 1, choose_uncommon)
end
