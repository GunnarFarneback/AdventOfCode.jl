part1(input) = sum(3 * mod(1 + x - a, 3) + 1 + x for (a, x) in parse_input(input))
part2(input) = sum(3 * x + 1 + mod(a + x - 1, 3) for (a, x) in parse_input(input))
parse_input(input) = ((line[1] - 'A', line[3] - 'X') for line in eachline(input))
