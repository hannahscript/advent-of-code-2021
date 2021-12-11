getinput() = readlines("input.txt")

function getclosing(par)
   return Dict('(' => ')', '{' => '}', '<' => '>', '[' => ']')[par]
end

function geterrorscore(par)
   return Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)[par]
end

function getcompletescore(par)
   return Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)[par]
end

function part1(input)
    score = 0
    for line in input
        stack::Vector{Char} = []
        for c in line
            if c in "([<{"
                push!(stack, getclosing(c))
            elseif isempty(stack)
                score += geterrorscore(c)
                break
            else
                expected = pop!(stack)
                if c != expected
                    score += geterrorscore(c)
                    break
                end
            end
        end
    end

    return score
end

function part2(input)
    scores::Vector{Int64} = []

    for line in input
        stack::Vector{Char} = []
        error = false
        for c in line
            if c in "([<{"
                push!(stack, getclosing(c))
            elseif isempty(stack)
                error = true
                break
            else
                expected = pop!(stack)
                error = c != expected
                error && break
            end
        end

        if !error
            score = 0
            for c in reverse(stack)
                score *= 5
                score += getcompletescore(c)
            end
            push!(scores, score)
        end
    end

    return sort(scores)[div(length(scores), 2)+1]
end

function solve()
    input = getinput()
    return part1(input), part2(input)
end

function main()
    p1, p2 = solve()
    println("Part 1: $(p1)") # 168417
    println("Part 2: $(p2)") # 2802519786
end

main()
