function part1(input)
    return count(support_tls.(eachline(input)))
end

function part2(input)
    return count(support_ssl.(eachline(input)))
end

function support_tls(ip)
    last_delimiter = 0
    hypernet = false
    abba_found = false
    for i = 1:length(ip)
        if ip[i] == '['
            hypernet = true
            last_delimiter = i
        elseif ip[i] == ']'
            hypernet = false
            last_delimiter = i
        elseif i - last_delimiter >= 4
            if ip[i] == ip[i - 3] && ip[i - 1] == ip[i - 2] && ip[i] != ip[i - 1]
                hypernet && return false
                abba_found = true
            end
        end
    end
    return abba_found
end

function support_ssl(ip)
    last_delimiter = 0
    hypernet = false
    ABA = Set{String}()
    BAB = Set{String}()
    for i = 1:length(ip)
        if ip[i] == '['
            hypernet = true
            last_delimiter = i
        elseif ip[i] == ']'
            hypernet = false
            last_delimiter = i
        elseif i - last_delimiter >= 3
            if ip[i] == ip[i - 2] && ip[i] != ip[i - 1]
                if hypernet
                    BAB = ip[(i - 1):i]
                else
                    ABA = ip[(i - 2):(i - 1)]
                end
            end
        end
    end
    return !isempty(intersect(ABA, BAB))
end
