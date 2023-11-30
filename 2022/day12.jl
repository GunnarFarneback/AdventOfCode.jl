part1(input) = search(input, Val(1))
part2(input) = search(input, Val(2))

function search(input, ::Val{part}) where part
    height = copy(input.data)
    stride = findfirst(==(UInt8('\n')), height)
    endpoint = findfirst(==(UInt8('E')), height)
    startpoint = findfirst(==(UInt8('S')), height)
    distance = fill(typemax(Int16), length(height))
    distance[endpoint] = 0
    height[endpoint] = UInt8('z')
    height[startpoint] = UInt8('a')
    queue = Vector{Int}(undef, length(height))
    queue[1] = endpoint
    queue_start = queue_end = 1
    @inbounds while queue_start <= queue_end
        p = queue[queue_start]
        queue_start += 1
        for n in (p - stride, p - 1, p + 1, p + stride)
            (n < 1 || n > length(height)) && continue
            distance[n] < typemax(Int16) && continue
            height[n] == UInt8('\n') && continue
            height[n] < height[p] - 0x01 && continue
            if part == 1
                n == startpoint && return distance[p] + 1
            else
                height[n] == UInt8('a') && return distance[p] + 1
            end
            distance[n] = distance[p] + 1
            queue_end += 1
            queue[queue_end] = n
        end
    end
    @assert false
end
