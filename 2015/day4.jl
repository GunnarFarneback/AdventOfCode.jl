using MD5: md5

part1(input) = md5search(input, 0x00f0ffff)
part2(input) = md5search(input, 0x00ffffff)

function md5search(input, mask)
    salt = readchomp(input)
    i = 1
    while first(reinterpret(UInt32, md5(string(salt, i)))) & mask != 0
        i += 1
    end
    return i
end
