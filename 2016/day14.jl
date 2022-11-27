using MD5: md5
using Multibreak

function part1(input)
    salt = readchomp(input)
    return search_keys(salt, part = 1)
end

function part2(input)
    salt = readchomp(input)
    return search_keys(salt, part = 2)
end

function search_keys(salt; part)
    digits = vcat('0':'9', 'a':'f')
    pentuplets = digits.^5
    found_triplets = Dict(c => Int[] for c in digits)
    found_keys = Int[]
    n = -1
    @multibreak while true
        n += 1
        hash = join(string.(md5(string(salt, n)), base = 16, pad = 2))
        if part == 2
            for i = 1:2016
                hash = join(string.(md5(hash), base = 16, pad = 2))
            end
        end
        for (digit, pentuplet) in zip(digits, pentuplets)
            if occursin(pentuplet, hash)
                while !isempty(found_triplets[digit])
                    m = popfirst!(found_triplets[digit])
                    if m >= n - 1000
                        push!(found_keys, m)
                    end
                end
                sort!(found_keys)
            end
        end
        for i = 1:30
            if hash[i] == hash[i + 1] == hash[i + 2]
                push!(found_triplets[hash[i]], n)
                break
            end
        end
        if length(found_keys) >= 64
            for digit in digits
                while first(found_triplets[digit]) < n - 1000
                    popfirst!(found_triplets[digit])
                end
                if first(found_triplets[digit]) < found_keys[64]
                    break; continue
                end
            end
            return found_keys[64]
        end
    end
end
