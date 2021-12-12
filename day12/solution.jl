function getinput()::Dict{String, Set{String}}
    graph = Dict()
    for line in readlines("input.txt")
        from, to = split(line, "-")
        if haskey(graph, from)
            push!(graph[from], to)
        else
            graph[from] = Set([to])
        end

        if haskey(graph, to)
            push!(graph[to], from)
        else
            graph[to] = Set([from])
        end
    end

    return graph
end

islargecave(node) = isuppercase(node[1])

function countpath(visited::Set{String}, current::String, graph::Dict{String, Set{String}})
    if current == "end"
        return 1
    end

    visitable = setdiff(graph[current], visited)
    sum = 0
    for node in visitable
        sum += countpath(islargecave(node) ? visited : push!(copy(visited), node), node, graph)
    end

    return sum
end

function countpath2(visited, current, graph)
    if current == "end"
        return 1
    end

    canvisittwice = all(<(2), values(visited))
    visitable = filter(node -> islargecave(node) || (node != "start" && (visited[node] < 1 || canvisittwice)), graph[current])
    sum = 0
    for node in visitable
        newvisited = copy(visited)
        newvisited[node] += islargecave(node) ? 0 : 1
        sum += countpath2(newvisited, node, graph)
    end

    return sum
end

function part1(graph)
    return countpath(Set(["start"]), "start", graph)
end

function part2(graph)
    visited::Dict{String, Int} = Dict()
    for k in keys(graph)
        visited[k] = 0
    end
    return countpath2(visited, "start", graph)
end

function solve()
    input = getinput()
    return part1(input), part2(input)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 1669
    println("Part 2: $(p2)") # 351
end

main()
