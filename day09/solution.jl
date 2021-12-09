function getinput()
    return readmatrix("input.txt", "", Int)
end

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

function countneighboursby(m, row, col, condition)
    count = 0

    for (dy, dx) in ((-1, 0), (1, 0), (0, -1), (0, 1))
        y = row + dy
        x = col + dx
        checkbounds(Bool, m, y, x) || continue



        count += condition(m[y, x]) ? 1 : 0
    end

    return count
end

function getneighboursby(m, condition, row, col)
    neighbours = []

    for (dy, dx) in ((-1, 0), (1, 0), (0, -1), (0, 1))
        y = row + dy
        x = col + dx
        checkbounds(Bool, m, y, x) || continue

        condition(m[y, x]) && push!(neighbours, (y, x))
    end

    return neighbours
end

function findlowpoints(depths)
    points = []
    for row in 1:size(depths, 1), col in 1:size(depths, 2)
        depth = depths[row, col]
        if countneighboursby(depths, row, col, <=(depth)) == 0
           push!(points, (row, col))
        end
    end

    return points
end

function part1(depths::Matrix{Int})
    lowpoints = findlowpoints(depths)
    map(p -> depths[p...] + 1, lowpoints) |> sum
end

function part2(depths::Matrix{Int})
    lowpoints = findlowpoints(depths)
    basins = map(p -> Set([p]), lowpoints)

    for basin in basins
        pneighbours = basin

        while true
            nneighbours = Set()
            for p in pneighbours
                union!(nneighbours, getneighboursby(depths, q -> q >= depths[p...] && q < 9, p...))
            end

            if issubset(nneighbours, basin)
                break
            end

            pneighbours = nneighbours
            union!(basin, nneighbours)
        end
    end

    return reverse(sort(basins .|> length))[1:3] |> prod
end

function solve()
    depths = getinput()
    return part1(depths), part2(depths)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 452
    println("Part 2: $(p2)") # 1263735
end

main()
