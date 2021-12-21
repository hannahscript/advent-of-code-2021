module Day20
    const Position = Tuple{Int, Int}

    struct Grid
        pixels::Dict{Position, Bool}
        xmin::Int
        xmax::Int
        ymin::Int
        ymax::Int
    end

    Base.copy(grid::Grid) = Grid(copy(grid.pixels), grid.xmin, grid.xmax, grid.ymin, grid.ymax)

    Base.:+(a::Position, b::Position) = (a[1] + b[1], a[2] + b[2])

    function getinput()
        lines = readlines("input.txt")

        rule = lines[1]

        width = length(lines[3])
        height = length(lines[3:end])
        pixels = Dict{Position, Bool}()
        y = 0
        map(lines[3:end]) do line
            x = 0
            for c in split(line, "")
                pixels[(y, x)] = c == "#"
                x += 1
            end

            y += 1
        end

        return rule, Grid(pixels, -1, width , -1, height )
    end

    function bitstoint(bits::BitVector)
        z = Int64(0)
        i = length(bits) - 1
        for d in bits
            z |= d << i
            i -= 1
        end

        return z
    end

    function getpixel(grid, pos, stepn)
        if pos[1] <= grid.xmin || pos[1] >= grid.xmax || pos[2] <= grid.ymin || pos[2] >= grid.ymax
            return stepn % 2 == 0
        end

        return get(grid.pixels, pos, false)
    end

    function getsquare(grid, center, stepn)
        result = Int64(0)
        i = 0
        for dy in 1:-1:-1, dx in 1:-1:-1
            result |= (getpixel(grid, center + (dy, dx), stepn)) << i
            i += 1
        end

        return result
    end

    function step(rule, grid, stepn)
        newpixels = copy(grid.pixels)
        for y in grid.ymin:grid.ymax, x in grid.xmin:grid.xmax
            sym = rule[getsquare(grid, (y, x), stepn) + 1]
            newpixels[(y, x)] = sym == '#'
        end

        return Grid(newpixels, grid.xmin-1, grid.xmax+1, grid.ymin-1, grid.ymax+1)
    end

    function printgrid(grid)
       gridys = map(p->p[1], keys(grid.pixels) |> collect)
       gridxs = map(p->p[1], keys(grid.pixels) |> collect)
       miny = minimum(gridys)
       maxy = maximum(gridys)
       minx = minimum(gridxs)
       maxx = maximum(gridxs)

       for y in miny:maxy
        for x in minx:maxx
            print(grid.pixels[(y, x)] ? "#" : ".")
        end
        println()
       end
    end

    function iterate(rule, grid, n)
        currentgrid = copy(grid)
        for i in 1:n
            currentgrid = step(rule, currentgrid, i)
        end

        return count(identity, values(currentgrid.pixels))
    end

    part1(rule, grid) = iterate(rule, grid, 2)

    part2(rule, grid) = iterate(rule, grid, 50)

    function solve()
        rule, grid = getinput()
        return part1(rule, grid), part2(rule, grid)
    end

    function main()
        p1, p2 = solve()
        println("Part 1: $(p1)") # 5464
        println("Part 2: $(p2)") # 19228
    end

    main()
end
