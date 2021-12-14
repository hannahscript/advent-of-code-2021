function getinput()
    lines = readlines("input.txt")
    axiom = split(lines[1], "")
    rules = Dict()
    for line in lines[3:end]
        from, to = split(line, " -> ")
        rules[from] = to
    end

    return axiom, rules
end

function step(axiom, rules)
    i = 1
    word = copy(axiom)
    while i < length(word)
        pair = join(word[i:i+1])
        if haskey(rules, pair)
           insert!(word, i+1, rules[pair])
           i += 1
        end

        i += 1
    end

    return word
end

function setorinc!(dict, key, v)
    av = get(dict, key, big(0))
    dict[key] = av + v
end

function step2(axiom, rules, counter)
    wordnew = copy(axiom)
    for (pair, n) in axiom
        if haskey(rules, pair)
            wordnew[pair] -= axiom[pair]
            setorinc!(counter, rules[pair], axiom[pair])
            npair1 = pair[1] * rules[pair]
            npair2 = rules[pair] * pair[2]
            setorinc!(wordnew, npair1, axiom[pair])
            setorinc!(wordnew, npair2, axiom[pair])
        end
    end

    return wordnew, counter
end

function part1(axiom, rules)
    word = axiom
    for i in 1:10
        word = step(word, rules)
        println((map(c -> c => count(==(c), word), unique(word))))
    end

    counts = sort(map(c -> count(==(c), word), unique(word)))
    return counts[end] - counts[1]
end

function aspairs(axiom)
    word::Dict{String, Int64} = Dict()
    for i in 1:length(axiom)-1
        pkey = join(axiom[i:i+1])
        if haskey(word, pkey)
            word[pkey] += 1
        else
            word[pkey] = 1
        end
    end

    return word
end

function part2(axiom, rules)
    word = aspairs(axiom)
    counter::Dict{String, BigInt} = Dict()
    for c in axiom
        setorinc!(counter, c, big(1))
    end

    for i in 1:40
        word, counter = step2(word, rules, counter)
    end

    counts = sort(values(counter) |> collect)
    println(counts)
    return counts[end] - counts[1]
end

function solve()
    axiom, rules = getinput()
    return part1(axiom, rules), part2(axiom, rules)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 3058
    println("Part 2: $(p2)") # 3447389044530
end

main()
