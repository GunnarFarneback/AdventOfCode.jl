mutable struct Particle
    p::Vector{Int}
    v::Vector{Int}
    a::Vector{Int}
end

function part1(input)
    particles = parse_line.(eachline(input))
    _, i = findmin(asymptotic_closeness, particles)
    return i - 1
end

function part2(input)
    particles = parse_line.(eachline(input))
    collisions = collide.(particles, permutedims(particles))
    for i in 1:length(particles)
        collisions[i, i] = -1
    end
    collision_times = sort(unique(collisions))
    all_destroyed = Int[]
    for t in collision_times
        t < 0 && continue
        destroyed = findall(vec(any(collisions .== t, dims = 2)))
        append!(all_destroyed, destroyed)
        collisions[destroyed, :] .= -1
        collisions[:, destroyed] .= -1
    end
    return length(particles) - length(all_destroyed)
end

function parse_line(line)
    x = parse.(Int, match(r"p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>", line).captures)
    return Particle(x[1:3], x[4:6], x[7:9])
end

function asymptotic_closeness(p::Particle)
    a = sum(abs.(p.a))
    v = sum(f.(p.v, p.a))
    p = sum(f.(p.p, p.a))
    return a, v, p
end

function f(x, a)
    if a > 0
        return x
    elseif a == 0
        return abs(x)
    else
        return -x
    end
end

function collide(particle1::Particle, particle2::Particle)
    da = particle1.a - particle2.a
    dv = particle1.v - particle2.v
    dp = particle1.p - particle2.p
    t1 = t2 = -1
    for i = 1:3
        a = da[i]
        v = dv[i]
        p = dp[i]
        if a == 0
            if v == 0
                if p != 0
                    return -1
                else
                    continue
                end
            else
                t1 = -p / v
            end
        else
            Δ = (2 * v + a)^2 - 8 * a * p
            if Δ < 0
                return -1
            end
            Δ = sqrt(Δ)
            if !isinteger(Δ)
                return -1
            end
            t1 = (-(2 * v + a) + Δ) / (2 * a)
            t2 = (-(2 * v + a) - Δ) / (2 * a)
        end
        for t in sort([t1, t2])
            if t < 0 || !isinteger(t)
                continue
            else
                if 2 .* dp .+ (2 .* dv .+ da) .* t .+ da .* t .* t == [0, 0, 0]
                    return Int(t)
                end
            end
        end
        return -1
    end
    return 0
end
