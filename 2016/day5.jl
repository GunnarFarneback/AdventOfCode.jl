using MD5: md5

function part1(input)
    id = readchomp(input)
    password = ""
    i = 0
    while length(password) < 8
        hash = join(string.(md5(string(id, i)), base = 16, pad = 2))
        if hash[1:5] == "00000"
            password *= hash[6]
        end
        i += 1
    end
    return password
end

function part2(input)
    id = readchomp(input)
    password = fill("", 8)
    i = -1
    while any(isempty.(password))
        i += 1
        hash = join(string.(md5(string(id, i)), base = 16, pad = 2))
        if hash[1:5] == "00000"
            position = hash[6]
            '0' <= position <= '7' || continue
            pos = parse(Int, position) + 1
            isempty(password[pos]) || continue
            password[pos] = hash[7:7]
        end
    end
    return join(password)
end
