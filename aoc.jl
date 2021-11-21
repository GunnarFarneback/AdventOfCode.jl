using Downloads: download

2 <= length(ARGS) <= 3 || error("Usage: julia aoc.jl YEAR DAY [TEST]")
year, day = ARGS[1:2]
test = length(ARGS) > 2
input_file = joinpath(@__DIR__, year, "input", "day$(day)")
if !isfile(input_file)
    mkpath(dirname(input_file))
    println("Downloading input for $year day $day.")
    session_cookie = read(joinpath(@__DIR__, "session_cookie"), String)
    download("https://adventofcode.com/$(year)/day/$(day)/input", input_file,
             headers = Dict("cookie" => "session=$(session_cookie)"))
end
include(joinpath(@__DIR__, year, "day$(day).jl"))
if test
    input_file *= ARGS[3]
end
if isdefined(Main, :part1)
    print("Part 1: ")
    test && print(ARGS[3])
    println()
    println(part1(input_file))
end
if isdefined(Main, :part2)
    print("Part 2: ")
    test && print(ARGS[3])
    println()
    println(part2(input_file))
end
