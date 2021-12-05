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

        return LineSegment(Point(x1, y1), Point(x2, y2))
    end
end

function ishorizontal(line)
    return line.a.y == line.b.y
end

function isvertical(line)
    return line.a.x == line.b.x
end

function getxs(line)
    return line.a.x:sign(line.b.x - line.a.x):line.b.x
end

function getys(line)
    return line.a.y:sign(line.b.y - line.a.y):line.b.y
end

function getpoints(line)
    if ishorizontal(line)
        xs = getxs(line)
        ys = fill(line.a.y, length(xs))
    elseif isvertical(line)
        ys = getys(line)
        xs = fill(line.a.x, length(ys))
    else
        xs = getxs(line)
        ys = getys(line)
    end

    return zip(xs, ys)
end

function count_intersections(lines)
    xmax = map(line -> max(line.a.x, line.b.x), lines) |> maximum
    ymax = map(line -> max(line.a.y, line.b.y), lines) |> maximum

    grid = zeros(ymax + 1, xmax + 1)
    for line in lines
        points = getpoints(line)
        for p in points
            grid[p[2] + 1, p[1] + 1] += 1
        end
    end

    return count(>(1), grid)
end

function part1(lines)
    allowedlines = filter(line -> isvertical(line) || ishorizontal(line), lines)
    return count_intersections(allowedlines)
end

function part2(lines)
    return count_intersections(lines)
end

function main()
    lines = getinput()
    println("Part 1: $(part1(lines))") # 6710
    println("Part 2: $(part2(lines))") # 20121
end

function bench()
    lines = getinput()
    part1(lines)
    part2(lines)
end

main()
