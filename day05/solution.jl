struct Point
    x::Int64
    y::Int64
end

struct LineSegment
    a::Point
    b:: Point
end

function getinput()
    lines = readlines("input.txt")
    return map(lines) do line
        (start, finish) = split(line, " -> ")
        (x1, y1) = parse.(Int64, split(start, ","))
        (x2, y2) = parse.(Int64, split(finish, ","))

        return LineSegment(Point(x1 + 1, y1 + 1), Point(x2 + 1, y2 + 1))
    end
end

function ishorizontal(line)
    return line.a.y == line.b.y
end

function isvertical(line)
    return line.a.x == line.b.x
end

function getseq(a, b)
    return a:sign(b - a):b
end

function getpoints(line)
    if ishorizontal(line)
        xs = getseq(line.a.x, line.b.x)
        ys = fill(line.a.y, length(xs))
    elseif isvertical(line)
        ys = getseq(line.a.y, line.b.y)
        xs = fill(line.a.x, length(ys))
    else
        xs = getseq(line.a.x, line.b.x)
        ys = getseq(line.a.y, line.b.y)
    end

    return zip(ys, xs)
end

function count_intersections(lines, grid)
    for line in lines, p in getpoints(line)
        grid[p[1], p[2]] += 1
    end

    return count(>(1), grid)
end

function partition(p, xs)
   matches = []
   rest = []
   for x in xs
       push!(p(x) ? matches : rest, x)
   end

   return (matches, rest)
end

function part1(lines, grid)
    return count_intersections(lines, grid)
end

function part2(lines, grid)
    return count_intersections(lines, grid)
end

function solve()
    lines = getinput()
    (straights, diagonals) = partition(line -> isvertical(line) || ishorizontal(line), lines)

    xmax = map(line -> max(line.a.x, line.b.x), lines) |> maximum
    ymax = map(line -> max(line.a.y, line.b.y), lines) |> maximum
    grid = zeros(ymax , xmax)

    return part1(straights, grid), part2(diagonals, grid)
end

p1, p2 = solve()
println("Part 1: $(p1)") # 6710
println("Part 2: $(p2)") # 20121
