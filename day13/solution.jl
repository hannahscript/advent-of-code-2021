struct Fold
    axis::String
    pos::Int
end

function getinput()
    dots::Vector{Pair{Int}} = []
    folds::Vector{Fold} = []
    for line in readlines("input.txt")
        pairmatch = match(r"(\d+),(\d+)", line)
        foldmatch = match(r"fold along (\w)=(\d+)", line)
        if (!isnothing(pairmatch))
            push!(dots, parse(Int, pairmatch[2]) + 1 => parse(Int, pairmatch[1]) + 1)
        elseif (!isnothing(foldmatch))
            push!(folds, Fold(foldmatch[1], parse(Int, foldmatch[2]) + 1))
        end
    end

    xmax = maximum(map(d -> d[2], dots))
    ymax = maximum(map(d -> d[1], dots))

    paper = zeros(Bool, ymax, xmax)
    for d in dots
        paper[d...] = true
    end

    return paper, folds
end

function fold(paper, fold)
    if fold.axis == "x"
        left = paper[:, 1:fold.pos-1]
        right = paper[:, end:-1:fold.pos+1]
        sl = size(left, 2)
        sr = size(right, 2)
        height = size(left, 1)
        if sl < sr
            left = hcat(zeros(Bool, height, sr - sl), left)
        elseif sl > sr
            right = hcat(zeros(Bool, height, sl - sr), right)
        end

        return left .| right
    elseif fold.axis == "y"
        up = paper[1:fold.pos - 1, :]
        down = paper[end:-1:fold.pos + 1, :]

        su = size(up, 1)
        sd = size(down, 1)
        width = size(up, 2)
        if su < sd
            up = vcat(zeros(Bool, sd - su, width), up)
        elseif su > sd
            down = vcat(zeros(Bool, su - sd, width), down)
        end

        return up .| down
    end
end

function part1(paper, folds)
    return fold(paper, folds[1]) |> sum
end

function part2(paper, folds)
    p = paper
    for f in folds
        p = fold(p, f)
    end

    "\n" * join(mapslices(row -> join(row, " "), replace(p, false => " ", true => "█"), dims=[2]), "\n")
end

function solve()
    paper, folds = getinput()
    return part1(paper, folds), part2(paper, folds)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 701
    println("Part 2: $(p2)") # fpekbejl
end

main()
