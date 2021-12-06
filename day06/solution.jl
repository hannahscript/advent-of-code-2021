function getinput()
    fishies = parse.(Int, split(readline("input.txt"), ",")) .+ 1
    timers = zeros(Int64, 9)
    for f in fishies
        timers[f] += 1
    end

    return timers
end

function dothefish(fish, days)
    for i in 1:days
        pregfish = fish[1]
        for t in 2:9
            fish[t - 1] = fish[t]
        end
        fish[9] = pregfish
        fish[7] += pregfish
    end

    return sum(values(fish))
end

part1(fish) = dothefish(fish, 80)

part2(fish) = dothefish(fish, 256 - 80)

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
