module Interpreter
    using ..Parser

    export interpret

    op_sum(packets::Vector{Packet})         = sum(interpret.(packets))
    op_prod(packets::Vector{Packet})        = prod(interpret.(packets))
    op_min(packets::Vector{Packet})         = minimum(interpret.(packets))
    op_max(packets::Vector{Packet})         = maximum(interpret.(packets))
    op_lessthan(packets::Vector{Packet})    = interpret(packets[1]) < interpret(packets[2])
    op_greaterthan(packets::Vector{Packet}) = interpret(packets[1]) > interpret(packets[2])
    op_equals(packets::Vector{Packet})      = interpret(packets[1]) == interpret(packets[2])

    operations = Dict(
        0 => op_sum,
        1 => op_prod,
        2 => op_min,
        3 => op_max,
        5 => op_greaterthan,
        6 => op_lessthan,
        7 => op_equals
    )

    interpret(packet::Parser.LiteralPacket) = packet.literal
    interpret(packet::Parser.OperatorPacket) = operations[packet.typeid](packet.packets)
end
