using Multibreak

function part1(input)
    scanners = parse_input(input)
    signatures = compute_signature.(scanners)
    overlaps = [length(intersect(s1, s2))
                for s1 in signatures, s2 in signatures]
    align_coordinates!(scanners, signatures, overlaps)
    return length(reduce(union, scanners))
end

function part2(input)
    scanners = parse_input(input)
    signatures = compute_signature.(scanners)
    overlaps = [length(intersect(s1, s2))
                for s1 in signatures, s2 in signatures]
    scanner_positions = align_coordinates!(scanners, signatures, overlaps)
    return maximum(sum(abs.(s1 .- s2)) for s1 in scanner_positions, s2 in scanner_positions)
end

function parse_input(input)
    scanners = Vector{Vector{Int}}[]
    for line in eachline(input)
        if occursin("scanner", line)
            push!(scanners, Vector{Int}[])
        elseif !isempty(line)
            push!(last(scanners), parse.(Int, split(line, ",")))
        end
    end
    return scanners
end

function compute_signature(scanner)
    return [sort(abs.(scanner[i] - scanner[j]))
            for i=1:length(scanner), j=1:length(scanner) if i > j]
end
    
function compute_signature2(scanner)
    return [sort(abs.(scanner[i] - scanner[j]))
            for i=1:length(scanner), j=1:length(scanner)]
end
    
function align_coordinates!(scanners, signatures, overlaps)
    aligned = [1]
    scanner_positions = [[0, 0, 0]]
    @multibreak while length(aligned) < length(scanners)
        for i in aligned
            for j in setdiff(1:length(scanners), aligned)
                if overlaps[i, j] >= 66
                    for signature in intersect(signatures[i], signatures[j])
                        if length(unique(signature)) == 3 && prod(signature) != 0
                            align_coordinates2!(scanners[i], scanners[j],
                                                signature, scanner_positions)
                            push!(aligned, j)
                            break; break; break
                        end
                    end
                end
            end
        end
    end
    return scanner_positions
end

function align_coordinates2!(scanner1, scanner2, signature, scanner_positions)
    s1 = compute_signature2(scanner1)
    s2 = compute_signature2(scanner2)
    a, b = Tuple(findfirst(s1 .== Ref(signature)))
    c, d = Tuple(findfirst(s2 .== Ref(signature)))
    d1 = scanner1[a] - scanner1[b]
    d2 = scanner2[c] - scanner2[d]
    for p in ([1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1])
        if abs.(d1) == abs.(d2[p])
            scanner2 .= (x -> x[p]).(scanner2)
            scanner2 .= (x -> x .* d2[p] ./ d1).(scanner2)
            if prod(d2) / prod(d1)  * (p[3] - p[1]) * (p[3] - p[2]) * (p[2] - p[1]) < 0
                scanner2 .= (x -> -x).(scanner2)
            end
            dd2 = scanner2[c] - scanner2[d]
            if d1 == dd2
                Δ = scanner1[a] .- scanner2[c]
            else
                Δ = scanner1[b] .- scanner2[c]
            end
            scanner2 .= (x -> x .+ Δ).(scanner2)
            push!(scanner_positions, Δ)
            return
        end
    end
end
