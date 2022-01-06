using AutoHashEquals

part1(input) = play(input, part = 1)
part2(input) = play(input, part = 2)

@auto_hash_equals mutable struct State
    mana::Int
    hero_hp::Int
    boss_hp::Int
    shield_timer::Int
    poison_timer::Int
    recharge_timer::Int
end

function play(input; part)
    boss_hp, boss_damage = parse.(Int, last.(split.(eachline(input), ": ")))
    hero_hp = 50
    hero_mana = 500

    queue = [(0, State(hero_mana, hero_hp, boss_hp, 0, 0, 0))]
    explored_states = Set{State}()
    while !isempty(queue)
        _, i = findmin(first, queue)
        spent_mana, state = queue[i]
        deleteat!(queue, i)

        if part == 2
            state.hero_hp -= 1
            state.hero_hp < 0 && continue
        end
        apply_effects!(state)
        state.boss_hp <= 0 && return spent_mana
        for spell! in (magic_missile!, drain!, shield!, poison!, recharge!)
            next_state = deepcopy(state)
            success, cost = spell!(next_state)
            success || continue
            next_state.mana -= cost
            next_state.boss_hp <= 0 && return spent_mana + cost
            apply_effects!(next_state)
            next_state.boss_hp <= 0 && return spent_mana + cost
            boss_hit!(next_state, boss_damage)
            next_state.hero_hp <= 0 && continue
            next_state in explored_states && continue
            push!(queue, (spent_mana + cost, next_state))
            push!(explored_states, next_state)
        end
    end
    @assert false
end

function apply_effects!(state)
    if state.poison_timer > 0
        state.boss_hp -= 3
    end
    if state.recharge_timer > 0
        state.mana += 101
    end
    state.shield_timer -= 1
    state.poison_timer -= 1
    state.recharge_timer -= 1
end

function magic_missile!(state)
    state.mana < 53 && return false, 53
    state.boss_hp -= 4
    return true, 53
end

function drain!(state)
    state.mana < 73 && return false, 73
    state.boss_hp -= 2
    state.hero_hp += 2
    return true, 73
end

function shield!(state)
    state.mana < 113 && return false, 113
    state.shield_timer > 0 && return false, 113
    state.shield_timer = 6
    return true, 113
end

function poison!(state)
    state.mana < 173 && return false, 173
    state.poison_timer > 0 && return false, 173
    state.poison_timer = 6
    return true, 173
end

function recharge!(state)
    state.mana < 229 && return false, 229
    state.recharge_timer > 0 && return false, 229
    state.recharge_timer = 5
    return true, 229
end

function boss_hit!(state, damage)
    armor = state.shield_timer >= 0 ? 7 : 0
    state.hero_hp -= max(1, damage - armor)
end
