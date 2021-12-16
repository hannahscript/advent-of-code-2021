module Day16
    include("parser.jl")
    include("interpreter.jl")

    function getinput()
        raw = readline("input.txt")
        number = parse(BigInt, raw, base=16)
        return BitVector(digits(Int8, number, base=2, pad=length(raw)*4) |> reverse)
    end

    addversions(packet::Parser.LiteralPacket) = packet.version
    addversions(packet::Parser.OperatorPacket) = packet.version + sum(addversions.(packet.packets))

    part1(packet) = addversions(packet)
    part2(packet) = Interpreter.interpret(packet)

    function solve()
        bits = getinput()
        state = Parser.ParserState(bits)
        packet = Parser.readpacket!(state)
        return part1(packet), part2(packet)
    end

    function main()
        p1, p2 = solve()
        println("Part 1: $(p1)") # 951
        println("Part 2: $(p2)") # 902198718880
    end

    main()
end
