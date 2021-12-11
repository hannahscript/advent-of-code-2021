getinput() = readmatrix("input.txt", "", Int64)

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

function addenergy(m, row, col)
    count = 0

    for dy in (-1, 0, 1), dx in (-1, 0, 1)
        dx == 0 && dy == 0 && continue
        y = row + dy
        x = col + dx
        checkbounds(Bool, m, y, x) || continue

        m[y, x] += 1
    end
end

function step(octo)
    flashes = 0

    flashed = Set()
    octo .+= 1
    while true
        f = findall(>(9), octo)
        f = filter(vec -> !(vec in flashed), f)
        if isempty(f)
            break
        end

        for v in f
            flashes += 1
            addenergy(octo, v[1], v[2])
        end

        union!(flashed, Set(f))
    end

    for v in flashed
        octo[v] = 0
    end

    #display(octo)
    #println()

    return flashes
end

function step2(octo)
    flashes = 0

    flashed = Set()
    octo .+= 1
    while true
        f = findall(>(9), octo)
        #if length(f) == length(octo)
        #    return true
        #end
        f = filter(vec -> !(vec in flashed), f)
        if isempty(f)
            break
        end

        for v in f
            flashes += 1
            addenergy(octo, v[1], v[2])
        end

        union!(flashed, Set(f))
    end

    for v in flashed
        octo[v] = 0
    end

    return sum(octo) == 0
end

function part1(octo)
    total = 0
    for i in 1:100
        total += step(octo)
    end

    return total
end

function part2(octo)
    i = 1
    while true
        if step2(octo)
            return i
        end
        i+=1
    end
end

function solve()
    input = getinput()
    return part1(copy(input)), part2(copy(input))
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") #
    println("Part 2: $(p2)") #
end

main()
