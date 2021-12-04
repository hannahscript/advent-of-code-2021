function getinput()
    lines = strip.(readlines("input.txt"))

    draws = parse.(Int, split(lines[1], ","))

    boards = []
    currentvec = []
    dim = split(lines[3], " ") |> length
    for line in lines[3:end]
        if isempty(line)
            push!(boards, reshape(currentvec, dim, dim))
            currentvec = []
        else
            append!(currentvec, parse.(Int, split(line, r"\s+")))
        end
    end

    return (draws=draws, boards=boards)
end

function strikedraw(board, draw)
    i = findfirst(==(draw), board)
    if isnothing(i)
        return false
    end
    board[i] = 0

    row = board[i[1], :]
    col = board[:, i[2]]

    return sum(row) == 0 || sum(col) == 0
end

function part1((draws, boards))
    for draw in draws
        for board in boards
            bingo = strikedraw(board, draw)

            if bingo
                return draw * sum(board)
            end
        end
    end
end

function part2((draws, boards))
    solved = Set()
    enumerated_boards = enumerate(boards)
    for draw in draws
        for (i, board) in enumerated_boards
            i in solved && continue

            bingo = strikedraw(board, draw)
            if bingo
                push!(solved, i)

                if (length(boards) == length(solved))
                    return draw * sum(board)
                end
            end
        end
    end
end

input = getinput()
println("Part 1: $(part1(input))") # 8442
println("Part 2: $(part2(input))") # 4590
