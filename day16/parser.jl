module Parser
    export Packet, LiteralPacket, OperatorPacket, readpacket!

    mutable struct ParserState
        bits::BitVector
        pos::Int64
    end

    ParserState(bits::BitVector) = ParserState(bits, 1)

    abstract type Packet end

    struct LiteralPacket <: Packet
        version::Int8
        typeid::Int8
        literal::Int64
    end

    struct OperatorPacket <: Packet
        version::Int8
        typeid::Int8
        packets::Vector{Packet}
    end

    function bitstoint(bits::BitVector)
        z = Int64(0)
        i = length(bits) - 1
        for d in bits
            z |= d << i
            i -= 1
        end

        return z
    end

    function readpacket!(state::ParserState)
        version, typeid = readheader!(state)
        if typeid == 4
            literal = readliteral!(state) |> bitstoint
            return LiteralPacket(version, typeid, literal)
        else
            lengthtypeid = readn!(state, 1) |> bitstoint

            if lengthtypeid == 0
                len = readn!(state, 15) |> bitstoint
                endpos = state.pos + len
                packets = readpacketsuntil!(state, endpos)
                return OperatorPacket(version, typeid, packets)
            else
                n = readn!(state, 11) |> bitstoint
                packets = readnpackets!(state, n)
                return OperatorPacket(version, typeid, packets)
            end
        end
    end

    function readpacketsuntil!(state::ParserState, pos)
        packets = Vector{Packet}()
        while state.pos < pos
           packet = readpacket!(state)
           push!(packets, packet)
        end

        return packets
    end

    function readnpackets!(state::ParserState, n)
        packets = Vector{Packet}()
        for i in 1:n
           packet = readpacket!(state)
           push!(packets, packet)
        end

        return packets
    end

    function readheader!(state::ParserState)
        version = readn!(state, 3) |> bitstoint
        typeid = readn!(state, 3) |> bitstoint
        return version, typeid
    end

    function readliteral!(state::ParserState)
        literal = BitVector()
        while true
            bits = readn!(state, 5)
            append!(literal, bits[2:end])
            bits[1] || break
        end

        return literal
    end

    function readn!(state::ParserState, n)
        nbits = state.bits[state.pos:state.pos + n - 1]
        state.pos += n
        return nbits
    end
end
