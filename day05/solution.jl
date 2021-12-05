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


function count_intersections(lines, grid, p)
     for line in lines
        !p(line) && continue

        sx = sign(line.b.x - line.a.x)
        sy = sign(line.b.y - line.a.y)

        if sx == 0 && sy == 0
            grid[line.a.y, line.a.x] += 1
            continue
        end

        if ishorizontal(line)
            x = line.a.x
            while x != line.b.x
                grid[line.a.y, x] += 1
                x += sx
            end
            grid[line.a.y, x] += 1
        elseif isvertical(line)
            y = line.a.y
            while y != line.b.y
                grid[y, line.a.x] += 1
                y += sy
            end
            grid[y, line.a.x] += 1
        else
            x = line.a.x
            y = line.a.y
            while x != line.b.x
                grid[y, x] += 1
                x += sx
                y += sy
            end
            grid[y, x] += 1
        end
    end

    return count(>(1), grid)
end

function solve()
    lines::Vector{LineSegment} = getinput()

    xmax = map(line -> max(line.a.x, line.b.x), lines) |> maximum
    ymax = map(line -> max(line.a.y, line.b.y), lines) |> maximum
    grid = zeros(Int8, ymax , xmax)

    return count_intersections(lines, grid, line -> isvertical(line) || ishorizontal(line)), count_intersections(lines, grid, line -> !(isvertical(line) || ishorizontal(line)))
end

p1, p2 = solve()
println("Part 1: $(p1)") # 6710
println("Part 2: $(p2)") # 20121
