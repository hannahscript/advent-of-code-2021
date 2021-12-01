function getinput()
    input = read("input.txt", String)
    lines = split(input, "\n")
    return map(line -> parse(Int64, line), filter(line -> !isempty(line), lines))
end

function part1(depths)
    increases = 0
    for i = 2:length(depths)
        if depths[i - 1] < depths[i]
            increases += 1
        end
    end

    return increases
end

function part2(depths)
    increases = 0
    for i = 4:length(depths)
        if depths[i] > depths[i - 3]
            increases += 1
        end
    end

    return increases
end

depths = getinput()
println("Part 1: " * string(part1(depths)))
println("Part 2: " * string(part2(depths)))
