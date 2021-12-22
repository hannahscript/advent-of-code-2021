module Day21
    mutable struct D100
        n::Int
        rolled::Int
    end

    struct State
        pos::Tuple{Int, Int}
        score::Tuple{Int, Int}
    end

    const Universe = Dict{State, BigInt}

    D100() = D100(1, 0)

    function roll(d::D100)
        n = d.n
        d.n = d.n % 100 + 1
        d.rolled += 1
        return n
    end

    function playturn(pos, d)
        rolls = roll(d) + roll(d) + roll(d)
        return (pos + rolls) % 10
    end

    function playround(starting, d)
        position = copy(starting)
        score = [0, 0]
        turn = 1

        while all(<(1000), score)
            position[turn] = playturn(position[turn], d)
            score[turn] += position[turn] + 1
            turn = turn % 2 + 1
        end

        return minimum(score) * d.rolled
    end

    function nextstate(state, player, rolls)
        pos = (state.pos[player] + rolls) % 10
        score = pos + 1
        if player == 1
            return State((pos, state.pos[2]), (min(state.score[1] + score, 21), state.score[2]))
        else
            return State((state.pos[1], pos), (state.score[1], min(state.score[2] + score, 21)))
        end
    end

    function inituniverse()
        universe = Universe()
        for pos1=0:9,pos2=0:9,score1=0:21,score2=0:21
            universe[State((pos1,pos2), (score1,score2))] = 0
        end

        return universe
    end

    function playturn2(universe::Universe, player)
        nextuniverse = inituniverse()
        for (state, n) in universe
            if any(>=(21), state.score)
                nextuniverse[state] += n
                continue
            end

            for a=1:3,b=1:3,c=1:3
                rolls = a + b + c
                nextuniverse[nextstate(state, player, rolls)] += n
            end
        end

        return nextuniverse
    end

    function getinput()
        return map(readlines("input.txt")) do line
            _, start = split(line, ": ")
            return parse(Int, start) - 1
        end
    end

    part1(starting) = playround(starting, D100())

    function part2(starting)
        universe = inituniverse()
        universe[State((starting[1], starting[2]), (0, 0))] = 1

        player = 1
        while any(((state, n),) -> state.score[1] < 21 && state.score[2] < 21 && n > 0, universe)
            universe = playturn2(universe, player)
            player = player % 2 + 1
        end

        p1wins = filter(((state, n),) -> state.score[1] == 21, universe) |> values |> sum
        p2wins = filter(((state, n),) -> state.score[2] == 21, universe) |> values |> sum
        return max(p1wins, p2wins)
    end

    function solve()
        starting = getinput()
        return part1(starting), part2(starting)
    end

    function main()
        p1, p2 = solve()
        println("Part 1: $(p1)") #
        println("Part 2: $(p2)") #
    end

    main()
end
