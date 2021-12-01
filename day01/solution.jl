function getinput()
    input = read("input.txt", String)
    lines = split(input, "\n")
    return map(line -> parse(Int64, line), lines)
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
    prevwindow = sum(depths[1:3])
    for i = 4:length(depths)
        window = prevwindow - depths[i - 3] + depths[i]
        if window > prevwindow
            increases += 1
        end

        prevwindow = window
    end

    return increases
end

depths = getinput()
println("Part 1: " * string(part1(depths)))
println("Part 2: " * string(part2(depths)))
