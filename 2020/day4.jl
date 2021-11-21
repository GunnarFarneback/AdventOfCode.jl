function part1(input)
    credentials = collect_credentials(readlines(input))
    return count(valid_credential, credentials)
end

function part2(input)
    credentials = collect_credentials(readlines(input))
    return count(valid_credential_values, credentials)
end

function collect_credentials(lines)
    credentials = Dict{String, String}[]
    credential = Dict{String, String}()
    for line in lines
        if isempty(line)
            push!(credentials, credential)
            credential = Dict{String, String}()
        end
        for pair in split(line, " ", keepempty = false)
            key, value = split(pair, ":")
            credential[key] = value
        end
    end
    !isempty(credential) && push!(credentials, credential)
    return credentials
end

function valid_credential(credential)
    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    return isempty(setdiff(required_fields, keys(credential)))
end

function valid_credential_values(credential)
    valid_credential(credential) || return false

    byr = credential["byr"]
    is_n_digit_number(byr, 4) || return false
    1920 <= parse(Int, byr) <= 2002 || return false

    iyr = credential["iyr"]
    is_n_digit_number(iyr, 4) || return false
    2010 <= parse(Int, iyr) <= 2020 || return false

    eyr = credential["eyr"]
    is_n_digit_number(eyr, 4) || return false
    2020 <= parse(Int, eyr) <= 2030 || return false

    hgt = credential["hgt"]
    if endswith(hgt, "in")
        n = tryparse(Int, first(split(hgt, "in")))
        isnothing(n) && return false
        59 <= n <= 76 || return false
    elseif endswith(hgt, "cm")
        n = tryparse(Int, first(split(hgt, "cm")))
        isnothing(n) && return false
        150 <= n <= 193 || return false
    else
        return false
    end

    hcl = credential["hcl"]
    isnothing(match(r"#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]", hcl)) && return false

    ecl = credential["ecl"]
    ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] || return false

    pid = credential["pid"]
    is_n_digit_number(pid, 9) || return false

    return true
end

function is_n_digit_number(s, n)
    return !isnothing(match(Regex("^" * "\\d" ^ n * "\$"), s))
end
