function getinput()
    return parse.(Int, split(readline("input.txt"), ","))
end

function dothefish(fish, days)
    timers = Dict(zip(0:8, zeros(Int64, 9)))
    for f in fish
        t = timers[f]
        timers[f] += 1
    end

    for i in 1:days
        pregfish = timers[0]
        for t in 1:8
            timers[t - 1] = timers[t]
        end
        timers[8] = pregfish
        timers[6] += pregfish
    end

    return sum(values(timers))
end

function part1(fish)
    dothefish(fish, 80)
end

function part2(fish)
    dothefish(fish, 256)
end

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
