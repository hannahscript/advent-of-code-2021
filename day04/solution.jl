function getinput()
    lines = strip.(readlines("input.txt"))

    draws = parse.(Int, split(lines[1], ","))

    dim = split(lines[3], " ") |> length
    # n + n * dim - 1 = length - 2
    boardtrix = Array{Int64}(undef, 5, 5, div(length(lines) - 1, 1 + dim))
    currentvec = []
    currentboard_n = 1
    for line in lines[3:end]
        if isempty(line)
            boardtrix[:, :, currentboard_n] = reshape(currentvec, dim, dim)
            currentvec = []
            currentboard_n += 1
        else
            append!(currentvec, parse.(Int64, split(line, r"\s+")))
        end
    end

    boardtrix[:, :, currentboard_n] = reshape(currentvec, dim, dim)

    return draws, boardtrix
end

function check_row(boards, b, y)
    for x in 1:size(boards)[2]
        if boards[y, x, b] != 0
            return false
        end
    end

    return true
end

function check_col(boards, b, x)
    for y in 1:size(boards)[1]
        if boards[y, x, b] != 0
            return false
        end
    end

    return true
end

function strikedraw(boards, b, draw)
    for col in 1:5, row in 1:5
        if boards[row, col, b] == draw
            boards[row, col, b] = 0
            return check_col(boards, b, col) || check_row(boards, b, row)
        end
    end
    return false
end

function part1((draws, boards))
    for draw in draws
        for b in 1:size(boards)[3]
            bingo = strikedraw(boards, b, draw)

            if bingo
                return draw * sum(boards[:, :, b])
            end
        end
    end
end

function part2((draws, boards))
    solved = Set()

    for draw in draws
        for b in 1:size(boards)[3]
            b in solved && continue

            bingo = strikedraw(boards, b, draw)
            if bingo
                push!(solved, b)

                if (size(boards)[3] == length(solved))
                    return draw * sum(boards[:, :, b])
                end
            end
        end
    end
end

function bench(input)
    draws = copy(input[1])
    boards = copy(input[2])
    p1 = part1((draws, boards))

    draws = copy(input[1])
    boards = copy(input[2])
    p2 = part2((draws, boards))
end

# Thank you Gandalf and Casey
function main()
    p1 = part1(getinput())
    p2 = part2(getinput())
    println("Part 1: $(p1)") # 8442
    println("Part 2: $(p2)") # 4590
end

main()
