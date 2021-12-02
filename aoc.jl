using Downloads: download
using BenchmarkTools

args = copy(ARGS)
(benchmark = "--benchmark" in args) && filter!(!=("--benchmark"), args)
length(args) >= 2 || error("Usage: julia aoc.jl YEAR DAY [TEST] [EXTRA_ARGS] [--benchmark]")
year, day = args[1:2]
test = length(args) > 2
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
    input_file *= args[3]
end
for part in (part1, part2)
    part == part2 && println()
    print("Part ", last(string(part)), ": ")
    test && print(args[3])
    println()
    println(part(input_file, args[4:end]...))
    if benchmark
        data = read(input_file)
        @btime $(part)(input, args[4:end]...) setup = (input = IOBuffer($data)) evals = 1
    end
end
