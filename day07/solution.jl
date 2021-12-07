using Statistics

getinput() = parse.(Int, split(readline("input.txt"), ","))

part1(input) = (input .- round(median(input))) .|> abs |> sum

crabdist(a, b) = sum(1:abs(a-b))
crabfuel(input, pos) = sum(input .|> c -> crabdist(c, pos))
function part2(input)
    initial = round(median(input))
    direction = sign(crabfuel(input, initial) - crabfuel(input, initial + 1))

    currentpos = initial
    currentfuel = crabfuel(input, currentpos)
    while true
       nextpos = currentpos + direction
       nextfuel = crabfuel(input, nextpos)
       if nextfuel > currentfuel
           break
       end

       currentpos = nextpos
       currentfuel = nextfuel
    end

    return crabfuel(input, currentpos)
end

function solve()
    input = getinput()
    return part1(input), part2(input)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") #
    println("Part 2: $(p2)") #
end

main()
