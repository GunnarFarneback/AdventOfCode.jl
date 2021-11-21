function part1(input)
    good_passwords = 0
    for line in readlines(input)
        n1, n2, c, password = match(r"(\d+)-(\d+) (\w): (\w+)", line).captures
        good_passwords += parse(Int, n1) <= count(==(c), split(password, "")) <= parse(Int, n2)
    end
    return good_passwords
end

function part2(input)
    good_passwords = 0
    for line in readlines(input)
        n1, n2, c, password = match(r"(\d+)-(\d+) (\w): (\w+)", line).captures
        m1, m2 = parse.(Int, (n1, n2))
        good_passwords += xor(password[m1:m1] == c, password[m2:m2] == c)
    end
    return good_passwords
end
