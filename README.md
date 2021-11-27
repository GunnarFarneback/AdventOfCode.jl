# Advent of Code in Julia

Julia solutions to [Advent of Code](https://adventofcode.com/)
problems. These are not designed for any particular purpose such as
speed, short code, pedagogical value, etc. but are simply whatever
solution first occured to me. You may learn something from reading
them or you may not. There are no code comments, consider it as part
of the challenge.

## Running the Solutions

`julia aoc.jl YEAR DAY [TEST] [EXTRA]`

Examples:

`julia aoc.jl 2020 1`

Run day 1 of 2020 using the problem input in `2020/input/day1`. See
next section about input files.

`julia aoc.jl 2020 10 test2`

Run day 10 of 2020 using the test input `2020/input/day10test2`.

`julia aoc.jl 2020 9 test 5`

Run day 9 of 2020 using the test input `2020/input/day9test` and
passing the value 5 as an extra positional argument to the solution
code.

## Input Files

Input files are named as indicated in the previous section. You need
to enter test files yourself but the real problem inputs will be
downloaded automatically if you extract your session cookie from your
web browser and place it in a file called `session_cookie` at the top
of your copy of the repository.