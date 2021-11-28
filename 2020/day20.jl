function part1(input)
    tiles = parse_input(input)
    edges = Dict(n => extract_edges(tile) for (n, tile) in tiles)
    edge_to_tile = Dict{Int, Vector{Int}}()
    for (tile_number, edge_codes) in edges
        for edge_code in edge_codes
            push!(get!(edge_to_tile, edge_code, Int[]), tile_number)
        end
    end
    square, _ = fit_into_square(edges, edge_to_tile)
    return prod(square[[1, end], [1, end]])
end

function part2(input)
    tiles = parse_input(input)
    edges = Dict(n => extract_edges(tile) for (n, tile) in tiles)
    edge_to_tile = Dict{Int, Vector{Int}}()
    for (tile_number, edge_codes) in edges
        for edge_code in edge_codes
            push!(get!(edge_to_tile, edge_code, Int[]), tile_number)
        end
    end
    square, square_edges = fit_into_square(edges, edge_to_tile)
    image = reconstruct_image(square, square_edges, tiles, edges)
    num_sea_monsters = find_sea_monsters.(vcat(rotl90.(Ref(image), 0:3),
                                               rotl90.(Ref(reverse(image, dims = 1)), 0:3)))
    n = only(filter(>(0), num_sea_monsters))
    return sum(image) - 15 * n
end

function parse_input(input)
    return Dict(parse_tile.(split(readchomp(input), "\n\n")))
end

function parse_tile(tile_string)
    lines = split(rstrip(tile_string), "\n")
    tile_number = parse(Int, only(match(r"Tile (\d+):", first(lines)).captures))
    tile = reduce(hcat, (split(line, "") .== "#" for line in lines[2:end]))
    return tile_number => tile
end

function extract_edges(tile)
    return encode_edge.([tile[1, :], reverse(tile[1, :]),
                         tile[:, end], reverse(tile[:, end]),
                         reverse(tile[end, :]), tile[end, :],
                         reverse(tile[:, 1]), tile[:, 1]])
end

function encode_edge(edge)
    return sum(1 .<< (i - 1)
               for (i, e) in enumerate(edge)
               if e)
end

const TOP = 1
const RIGHT = 2
const BOTTOM = 3
const LEFT = 4

function fit_into_square(edges, edge_to_tile)
    side = isqrt(length(edges))
    @assert side^2 == length(edges)
    square = zeros(Int, side, side)
    square_edges = zeros(Int, side, side, 4)
    for (tile, edge_codes) in edges
        used_tiles = Set(tile)
        square[1, 1] = tile
        for i = 1:8
            square_edges[1, 1, :] .= get_tile_permutation(edge_codes, i)
            if fit_rest_of_square!(square, square_edges, used_tiles,
                                   edges, edge_to_tile)
                return square, square_edges
            end
        end
    end
    error("No solution found.")
end

function fit_rest_of_square!(square, square_edges, used_tiles,
                            edges, edge_to_tile)
    side = size(square, 1)
    for (i, j) in Tuple.(CartesianIndices((1:side, 1:side))[2:end])
        if i == 1
            left_edge = square_edges[i, j - 1, RIGHT]
            fitting_tiles = setdiff(edge_to_tile[left_edge], square[i, j - 1])
            isempty(fitting_tiles) && return false
            square[i, j] = only(fitting_tiles)
            square_edges[i, j, :] = get_tile_edges(edges[square[i, j]],
                                                   left_edge, LEFT)
        else
            top_edge = square_edges[i - 1, j, BOTTOM]
            fitting_tiles = setdiff(edge_to_tile[top_edge], square[i - 1, j])
            isempty(fitting_tiles) && return false
            square[i, j] = only(fitting_tiles)
            square_edges[i, j, :] = get_tile_edges(edges[square[i, j]],
                                                   top_edge, TOP)
            if j > 1 && square_edges[i, j - 1, RIGHT] != square_edges[i, j, LEFT]
                return false
            end
        end
    end
    return true
end

function get_tile_edges(edge_codes, given_edge, position)
    @assert given_edge in edge_codes
    @assert position in (TOP, LEFT)
    if position == TOP
        if findfirst(==(given_edge), edge_codes) % 2 == 0
            edge_codes = reverse(edge_codes)
        end
        n = findfirst(==(given_edge), edge_codes)
        edge_codes = edge_codes[mod1.(n .+ (0:7), 8)]
    elseif position == LEFT
        if findfirst(==(given_edge), edge_codes) % 2 == 1
            edge_codes = reverse(edge_codes)
        end
        n = findfirst(==(given_edge), edge_codes)
        edge_codes = edge_codes[mod1.(n .+ (1:8), 8)]
    end
    return edge_codes[[1, 3, 6, 8]]
end

function get_tile_permutation(edge_codes, i)
    if i > 4
        edge_codes = reverse(edge_codes)
        i -= 4
    end
    edge_codes = edge_codes[mod1.(2 * i .+ (-1:6), 8)]
    return edge_codes[[1, 3, 6, 8]]
end

function reconstruct_image(square, square_edges, tiles, edges)
    image = zeros(Int, 8 .* size(square))
    side = size(square, 1)
    for (i, j) in Tuple.(CartesianIndices((1:side, 1:side)))
        tile = extract_tile(square[i, j], square_edges[i, j, :], tiles, edges)
        image[(1 + 8 * (i - 1)):(8 * i), (1 + 8 * (j - 1)):(8 * j)] .= tile
    end
    return image
end

function extract_tile(tile_number, tile_edges, tiles, edges)
    tile = tiles[tile_number]
    n = findfirst(==(tile_edges[1]), edges[tile_number])
    if n % 2 == 1
        tile = rotl90(tile, (n - 1) ÷ 2)
    else
        tile = reverse(tile, dims = 2)
        tile = rotr90(tile, (n - 2) ÷ 2)
    end
    @assert encode_edge(tile[1, :]) == tile_edges[1]
    return tile[2:(end - 1), 2:(end - 1)]
end

function find_sea_monsters(image)
    sea_monster = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
                   1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 1
                   0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0]
    N = sum(sea_monster)
    num_sea_monsters = 0
    for j = 1:(size(image, 2) - 19)
        for i = 1:(size(image, 1) - 2)
            if sum(image[i:(i + 2), j:(j + 19)] .* sea_monster) == N
                num_sea_monsters += 1
            end
        end
    end
    return num_sea_monsters
end

