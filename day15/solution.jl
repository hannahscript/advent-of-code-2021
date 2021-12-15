getinput() = readmatrix("input.txt", "", Int)

function readmatrix(path, sep, type)
   raw = readlines(path)
   rows = length(raw)
   vecform = raw .|> line -> split(line, sep)
   cols = length(vecform[1])
   m = Matrix{type}(undef, rows, cols)
   for row in 1:rows, col in 1:cols
        m[row, col] = parse(type, vecform[row][col])
   end
   return m
end

function forneighbours(fn, m, center)
    for dci in [CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(1, 0)]
        ci = dci + center
        checkbounds(Bool, m, ci) || continue

        fn(ci)
    end
end

function dijkstra(graph)
    dist = fill(typemax(Int64), size(graph))
    visited = falses(size(graph))

    current = CartesianIndex(1, 1)
    target = CartesianIndex(size(graph))

    dist[1, 1] = 0
    graph[1, 1] = 0

    while current != target
        forneighbours(graph, current) do ci
            visited[ci] && return
            dist[ci] = min(dist[ci], dist[current] + graph[ci])
        end

        visited[current] = true
        current = argmin(dist .+ (visited * 9999999))
    end

    return dist[current]
end

function embiggen(graph)
    ralph = Matrix{Int}(undef, size(graph) .* 5)
    height = size(graph, 1)
    width = size(graph, 2)
    for row in 1:5, col in 1:5
        rowstart = 1+(row-1)*height
        colstart = 1+(col-1)*width
        ralph[CartesianIndices((rowstart:rowstart+height-1, colstart:colstart+width-1))] = graph .+ (row+col-2)
        ralph = map(n -> n>9 ? n%10 + div(n, 10) : n, ralph)
    end

    return ralph
end

part1(graph) = dijkstra(graph)

part2(graph) = dijkstra(embiggen(graph))

function solve()
    graph = getinput()
    return part1(copy(graph)), @time part2(copy(graph))
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 487
    println("Part 2: $(p2)") # 2821
end

main()
