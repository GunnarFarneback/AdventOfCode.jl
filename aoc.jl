using Downloads: download

length(ARGS) >= 2 || error("Usage: julia aoc.jl YEAR DAY [TEST] [EXTRA_ARGS]")
year, day = ARGS[1:2]
test = length(ARGS) > 2
input_file = joinpath(@__DIR__, year, "input", "day$(day)")
if !isfile(input_file)
    mkpath(dirname(input_file))
    println("Downloading input for $year day $day.")
    session_cookie_file = joinpath(@__DIR__, "session_cookie")
    if isfile(session_cookie_file)
        session_cookie = read(session_cookie_file, String)
        download("https://adventofcode.com/$(year)/day/$(day)/input",
                 input_file,
                 headers = Dict("cookie" => "session=$(session_cookie)"))
    else
        println("No session cookie available. Download the input file manually and save it to $(input_file)")
    end
end
include(joinpath(@__DIR__, year, "day$(day).jl"))
if test
    input_file *= ARGS[3]
end
if isdefined(Main, :part1)
    print("Part 1: ")
    test && print(ARGS[3])
    println()
    println(part1(input_file, ARGS[4:end]...))
end
if isdefined(Main, :part2)
    print("Part 2: ")
    test && print(ARGS[3])
    println()
    println(part2(input_file, ARGS[4:end]...))
end
