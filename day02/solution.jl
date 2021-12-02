struct Command
    name::String
    arg1::Int64
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

function part1(commands)
    depth = 0
    horizontal = 0

    for cmd in commands
        if cmd.name == "up"
            depth -= cmd.arg1
        elseif cmd.name == "down"
            depth += cmd.arg1
        elseif cmd.name == "forward"
            horizontal += cmd.arg1
        else
            throw(DomainError(cmd, "Unknown command"))
        end
    end

    return depth * horizontal
end

function part2(commands)
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

    return depth * horizontal
end

commands = getinput()
println("Part 1: " * string(part1(commands)))
println("Part 2: " * string(part2(commands)))
