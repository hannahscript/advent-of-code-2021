struct Command
    name::String
    arg1::Int64
end

struct EndPosition
    aim::Int64
    depth::Int64
    horizontal::Int64
end

function parsecommand(word)
    (name, arg) = split(word)
    return Command(name, parse(Int64, arg))
end

function getinput()
    input = read("input.txt", String)
    lines = split(input, "\n")
    return map(parsecommand, filter(line -> !isempty(line), lines))
end

function steer(commands)
    depth = 0
    horizontal = 0
    aim = 0

    for cmd in commands
        if cmd.name == "up"
            aim -= cmd.arg1
        elseif cmd.name == "down"
            aim += cmd.arg1
        elseif cmd.name == "forward"
            horizontal += cmd.arg1
            depth += aim * cmd.arg1
        else
            throw(DomainError(cmd, "Unknown command"))
        end
    end

    return EndPosition(aim, depth, horizontal)
end

part1(endpos) = endpos.aim * endpos.horizontal

part2(endpos) = endpos.depth * endpos.horizontal

endpos = getinput() |> steer
println("Part 1: " * string(part1(endpos)))
println("Part 2: " * string(part2(endpos)))
