part1(input) = join(next_password(collect(readchomp(input))))
part2(input) = join(next_password(next_password(collect(readchomp(input)))))

function next_password(password)
    next_string!(password)
    while !is_valid(password)
        next_string!(password)
    end
    return password
end

function is_valid(password)
    'i' in password && return false
    'l' in password && return false
    'o' in password && return false
    has_triple = any(password[i + 1] == password[i] + 1 && password[i + 2] == password[i] + 2 for i = 1:6)
    has_triple || return false
    i = 1
    pairs = 0
    while i <= 7
        if password[i] == password[i + 1]
            pairs += 1
            i += 2
        else
            i += 1
        end
    end
    return pairs >= 2
end

function next_string!(password)
    for i = 8:-1:1
        password[i] += 1
        if password[i] > 'z'
            password[i] = 'a'
        else
            break
        end
    end
end
