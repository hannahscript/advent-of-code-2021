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

    xmax = folds[findfirst(f -> f.axis == "x", folds)].pos * 2 - 1
    ymax = folds[findfirst(f -> f.axis == "y", folds)].pos * 2 - 1

    paper = falses(ymax, xmax)
    for d in dots
        paper[d...] = true
    end

    return paper, folds
end

fold(paper, fold) = fold.axis == "x" ? paper[:, 1:fold.pos - 1] .| paper[:, end:-1:fold.pos + 1] : paper[1:fold.pos - 1, :] .| paper[end:-1:fold.pos + 1, :]

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
