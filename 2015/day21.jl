part1(input) = optimize_equipment(input, part = 1)
part2(input) = optimize_equipment(input, part = 2)

function optimize_equipment(input; part)
    boss_stats = parse.(Int, last.(split.(eachline(input), ": ")))
    hero_hp = 100
    weapons = [(  8, 4, 0),
               ( 10, 5, 0),
               ( 25, 6, 0),
               ( 40, 7, 0),
               ( 74, 8, 0)]
    armors = [(  0, 0, 0),
              ( 13, 0, 1),
              ( 31, 0, 2),
              ( 53, 0, 3),
              ( 75, 0, 4),
              (102, 0, 5)]
    rings = [(  0, 0, 0),
             ( 25, 1, 0),
             ( 50, 2, 0),
             (100, 3, 0),
             ( 20, 0, 1),
             ( 40, 0, 2),
             ( 80, 0, 3)]

    best_cost = part == 1 ? typemax(Int) : 0
    for weapon in weapons, armor in armors, ring1 in rings, ring2 in rings
        0 < ring2[1] <= ring1[1] && continue
        ring2[1] < ring1[1] && continue
        cost, hero_damage, hero_armor = weapon .+ armor .+ ring1 .+ ring2
        part == 1 && cost >= best_cost && continue
        part == 2 && cost <= best_cost && continue
        if fight(hero_hp, hero_damage, hero_armor, boss_stats...) ⊻ (part == 2)
            best_cost = cost
        end
    end
    return best_cost
end

function fight(hp1, damage1, armor1, hp2, damage2, armor2)
    while true
        hp2 -= max(1, damage1 - armor2)
        hp2 <= 0 && return true
        hp1 -= max(1, damage2 - armor1)
        hp1 <= 0 && return false
    end
end
