function getinput()
    lines = readlines("input.txt")
    return map(bits -> parse.(Int, bits), split.(lines, ""))
end

find_most_common(report) = sum(report) .>= length(report) / 2

function part1(most_common)
    most_common = find_most_common(report)
    rates = [0, 0]
    for (i, d) in enumerate(reverse(most_common))
        rates[d + 1] += 2 ^ (i - 1)
    end

    return prod(rates)
end

function part2(report)
    ratings = [0, 0]

    for r = 1:2
        leftovers = report
        most_common = find_most_common(leftovers)
        for i in 1:length(most_common)
            leftovers = filter(line -> r == 1 ? line[i] == most_common[i] : line[i] != most_common[i], leftovers)
            if (length(leftovers) == 1)
                ratings[r] = parse(Int, join(leftovers[1]), base=2)
                break
            end

            most_common = find_most_common(leftovers)
        end
    end

    return prod(ratings)
end

report = getinput()
println("Part 1: $(part1(report))") # 1092896
println("Part 2: $(part2(report))") # 4672151
