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

function addenergy(m, center)
    count = 0

    for ci in (CartesianIndices((-1:1, -1:1)) .+ center)
        ci[1] == 0 && ci[2] == 0 && continue
        checkbounds(Bool, m, ci) || continue

        m[ci] += 1
    end
end

function step(octo, flashed)
    flashes = 0

    octo .+= 1
    while true
        cis = filter(ci -> !flashed[ci], findall(>(9), octo))
        isempty(cis) && break

        flashes += length(cis)
        addenergy.((octo,), cis)
        flashed[cis] .= true
    end

    octo .*= .! flashed
    flashed .= false

    return flashes
end

function part1(octo, flashed)
    total = 0
    for i in 1:100
        total += step(octo, flashed)
    end

    return total
end

function part2(octo, flashed)
    i = 100
    while true
        i += 1
        if step(octo, flashed) == length(octo)
            return i
        end
    end
end

function solve()
    input = getinput()
    flashed = fill(false, size(input))
    return part1(input, flashed), part2(copy(input), flashed)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 1669
    println("Part 2: $(p2)") # 351
end

main()
