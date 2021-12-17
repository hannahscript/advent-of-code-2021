module Day17
    mutable struct Probe
        pos::Vector{Int}
        vel::Vector{Int}
    end

    Probe(vx, vy) = Probe([0, 0], [vx, vy])

    function getinput()
        line = readline("input.txt")
        m = match(r"x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)", line)
        return parse.(Int, [m[1], m[2], m[3], m[4]])
    end

    intarget(probe, target) = probe.pos[1] in target[1]:target[2] && probe.pos[2] in target[3]:target[4]

    function step(probe)
        probe.pos += probe.vel
        probe.vel -= [sign(probe.vel[1]), 1]
    end

    hopeless(probe, target) = probe.pos[1] > target[2] || probe.pos[2] < target[3]

    function probe(probe, target)
        while true
            step(probe)
            hopeless(probe, target) && return false
            intarget(probe, target) && return true
        end
    end

    gauss(n) = div(n*(n+1), 2)

    function part1(target)
        best = 1
        for vx in 1:target[2]+1
            for vy in 1:abs(target[3])+1
                p = Probe(vx, vy)
                if probe(p, target)
                    best = gauss(vy)
                end
            end
        end
        return best
    end

    function part2(target)
        count = 0
        for vx in 1:target[2]+1
            for vy in target[3]-1:abs(target[3])+1
                p = Probe(vx, vy)
                if probe(p, target)
                    count += 1
                end
            end
        end
        return count
    end

    function solve()
        target = getinput()
        return part1(target), part2(target)
    end

    function main()
        p1, p2 = @time solve()
        println("Part 1: $(p1)") # 33670
        println("Part 2: $(p2)") # 4903
    end

    main()
end
