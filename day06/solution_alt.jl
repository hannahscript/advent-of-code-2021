function getinput()
    fishies = parse.(Int, split(readline("input.txt"), ",")) .+ 1
    timers = zeros(Int64, 9)
    for f in fishies
        timers[f] += 1
    end

    return timers
end

# matrix idea thanks to pythongirl
function dothefish(fish, days)
    m::Matrix{BigInt} =
        [0 1 0 0 0 0 0 0 0;
         0 0 1 0 0 0 0 0 0;
         0 0 0 1 0 0 0 0 0;
         0 0 0 0 1 0 0 0 0;
         0 0 0 0 0 1 0 0 0;
         0 0 0 0 0 0 1 0 0;
         1 0 0 0 0 0 0 1 0;
         0 0 0 0 0 0 0 0 1;
         1 0 0 0 0 0 0 0 0]

    return sum(m ^ days * fish)
end


part1(fish) = dothefish(fish, 80)

part2(fish) = dothefish(fish, 256)

function solve()
    fish = getinput()
    return part1(fish), part2(fish)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 355386
    println("Part 2: $(p2)") # 1613415325809
end

main()
