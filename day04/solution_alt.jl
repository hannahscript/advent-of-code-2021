# algorithm thanks to cassy

function solve()
    lines = map(lstrip, [readlines("input.txt") ; ""])

    draws = map(n -> parse(Int, n), split(lines[1], ","))
    turnfordraw = Array{Int64}(undef, length(draws))
    for (i, draw) in enumerate(draws)
        turnfordraw[draw + 1] = i
    end

    best = (turn = 999, board = nothing)
    worst = (turn = 0, board = nothing)
    currentboard = Matrix{Int64}(undef, 5, 5)
    mrow = 1
    for line in lines[3:end]
        if isempty(line)
            turn = getturn(currentboard, turnfordraw)

            if (turn < best.turn)
                best = (turn = turn, board = copy(currentboard))
            elseif (turn > worst.turn)
                worst = (turn = turn, board = copy(currentboard))
            end

            mrow = 1
        else
            currentboard[mrow, :] = parse.(Int64, split(line, r"\s+"))
            mrow += 1
        end
    end

    best.board[findall(n -> n in draws[1:best.turn], best.board)] .= 0
    worst.board[findall(n -> n in draws[1:worst.turn], worst.board)] .= 0
    p1 = draws[best.turn] * sum(best.board)
    p2 = draws[worst.turn] * sum(worst.board)

    return p1, p2
end

function getturn(board, turnfordraw)
    turn = 999
    for col in 1:5
        m = 0
        for row in 1:5
            m = max(turnfordraw[board[row, col] + 1], m)
        end
        turn = min(turn, m)
    end

    for row in 1:5
        m = 0
        for col in 1:5
            m = max(turnfordraw[board[row, col] + 1], m)
        end
        turn = min(turn, m)
    end

    return turn
end

println(solve())
