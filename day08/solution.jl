struct Input
    signals::Vector{String}
    segments::Vector{String}
end

function group(segments, signals)
    return Group(Set(segments), Set(signals))
end

function getinput()
    return map(readlines("input.txt")) do line
        signalpart, segmentpart = split(line, "|")
        signals = split(signalpart) .|> strip
        segments = split(segmentpart) .|> strip
        return Input(signals, segments)
    end
end

function part1(input)
    return (map(ip -> ip.segments, input) .|> segments -> count(segment -> length(segment) in [2, 3, 4, 7], segments)) |> sum
end

function findandremove!(p, vec)
    i = findfirst(p, vec)
    value = vec[i]
    deleteat!(vec, i)
    return Set(value)
end

function solvedisplay(display::Input)
    signals = copy(display.signals)
    # Find obvious numbers
    numbers = Dict()
    numbers[1] = findandremove!(s -> length(s) == 2, signals)
    numbers[4] = findandremove!(s -> length(s) == 4, signals)
    numbers[7] = findandremove!(s -> length(s) == 3, signals)
    numbers[8] = findandremove!(s -> length(s) == 7, signals)
    # 3 is the only number with 5 segments that overlaps with 1 completely
    numbers[3] = findandremove!(s -> length(s) == 5 && issubset(numbers[1], Set(s)), signals)
    # 9 is the only number with 6 ssegments that overlaps with 4 completely
    numbers[9] = findandremove!(s -> length(s) == 6 && issubset(numbers[4], Set(s)), signals)
    # 0 is the only number with 6 segments left that overlaps with 1 completely
    numbers[0] = findandremove!(s -> length(s) == 6 && issubset(numbers[1], Set(s)), signals)
    # 6 is the only number with 6 segments left
    numbers[6] = findandremove!(s -> length(s) == 6, signals)
    # 5 is the only subset of 6 left
    numbers[5] = findandremove!(s -> issubset(Set(s), numbers[6]), signals)
    # 2 is the remaining number
    numbers[2] = Set(signals[1])

    translator = Dict(v => k for (k, v) in numbers)
    m = 1000
    total = 0
    for seg in display.segments
        total += m * translator[Set(seg)]
        m = div(m, 10)
    end

    return total
end

function part2(input)
    return sum(input .|> solvedisplay)
end

function solve()
    input = getinput()
    return part1(input), part2(input)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 255
    println("Part 2: $(p2)") # 982158
end

main()
