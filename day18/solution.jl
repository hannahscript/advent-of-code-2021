module Day18
    abstract type Tree end

    mutable struct Node <: Tree
        parent::Union{Node, Nothing}
        left::Tree
        right::Tree
    end

    mutable struct Leaf <: Tree
        parent::Union{Node, Nothing}
        label::Int
    end

    function Node(parent, leftlabel::Int, rightlabel::Int)
        left = Leaf(nothing, leftlabel)
        right = Leaf(nothing, rightlabel)
        node = Node(parent, left, right)
        left.parent = node
        right.parent = node
    end

    Base.copy(leaf::Leaf) = Leaf(leaf.parent, leaf.label)
    function Base.copy(node::Node)
        left = copy(node.left)
        right = copy(node.right)
        new = Node(node.parent, left, right)
        left.parent = new
        right.parent = new
        return new
    end

    Base.show(io::IO, leaf::Leaf) = print(io, "$(leaf.label)")
    Base.show(io::IO, node::Node) = print(io, "[$(node.left), $(node.right)]")

    parsetree(e::Int) = parsetree(e, nothing)
    parsetree(e::Vector) = parsetree(e, nothing)
    parsetree(e::Int, parent) = Leaf(parent, e)
    function parsetree(e::Vector, parent)
        left = parsetree(e[1])
        right = parsetree(e[2])
        node = Node(parent, left, right)
        left.parent = node
        right.parent = node
    end

    isroot(tree::Tree) = isnothing(tree.parent)

    rightmost(leaf::Leaf) = leaf
    rightmost(node::Node) = rightmost(isnothing(node.right) ? node.left : node.right)

    leftmost(leaf::Leaf) = leaf
    leftmost(node::Node) = leftmost(isnothing(node.left) ? node.right : node.left)

    function findleft(leaf::Leaf)
        prev = leaf
        current = leaf.parent
        while !isnothing(current) && (isnothing(current.left) || current.left === prev)
            prev = current
            current = current.parent
        end

        isnothing(current) && return nothing

        return rightmost(current.left)
    end

    function findright(leaf::Leaf)
        prev = leaf
        current = leaf.parent
        while !isnothing(current) && (isnothing(current.right) || current.right === prev)
            prev = current
            current = current.parent
        end

        isnothing(current) && return nothing

        return leftmost(current.right)
    end

    function replace(node::Tree, replacement::Tree)
        if node.parent.left === node
            node.parent.left = replacement
        else
            node.parent.right = replacement
        end
    end

    function explode(node::Node)
        left = findleft(node.left)
        right = findright(node.right)

        if !isnothing(left)
            left.label += node.left.label
        end
        if !isnothing(right)
            right.label += node.right.label
        end

        replace(node, Leaf(node.parent, 0))
    end

    function split(leaf::Leaf)
        replace(leaf, Node(leaf.parent, div(leaf.label, 2), div(leaf.label, 2) + isodd(leaf.label)))
    end

    finddepth(leaf::Leaf, depth) = nothing
    finddepth(n::Nothing, depth) = nothing
    function finddepth(node::Node, depth)
        depth == 0 && return node
        left = finddepth(node.left, depth - 1)
        return isnothing(left) ? finddepth(node.right, depth - 1) : left
    end

    findgte10(leaf::Leaf) = leaf.label >= 10 ? leaf : nothing
    findgte10(n::Nothing) = nothing
    function findgte10(node::Node)
        left = findgte10(node.left)
        return isnothing(left) ? findgte10(node.right) : left
    end

    function reduce(tree::Tree)
        while true
            pair = finddepth(tree, 4)
            if isnothing(pair)
                leaf = findgte10(tree)
                isnothing(leaf) && return
                split(leaf)
            else
                explode(pair)
            end
        end
    end

    function add(a::Tree, b::Tree)
        tree = Node(nothing, a, b)
        a.parent = tree
        b.parent = tree
        reduce(tree)
        tree
    end

    findleaf(n::Nothing, value::Int) = nothing
    findleaf(leaf::Leaf, value::Int) = isnothing(leaf) || leaf.label != value ? nothing : leaf
    function findleaf(node::Node, value::Int)
        left = findleaf(node.left, value)
        return isnothing(left) ? findleaf(node.right, value) : left
    end

    magnitude(leaf::Leaf) = leaf.label
    magnitude(n::Nothing) = 0
    magnitude(node::Node) = 3 * magnitude(node.left) + 2 * magnitude(node.right)

    function getinput()
        map(readlines("input.txt")) do line
            return line |> Meta.parse |> eval |> parsetree
        end
    end

    function part1(trees)
        foldl(add, trees) |> magnitude
    end

    function part2(trees)
        best = 0
        println(trees)
        for a in trees, b in trees
            a === b && continue
            ac = copy(a)
            bc = copy(b)
            best = max(best, add(ac, bc) |> magnitude)
            ac = copy(a)
            bc = copy(b)
            best = max(best, add(bc, ac) |> magnitude)
        end

        return best
    end

    function solve()
        trees = getinput()
        return part1(deepcopy(trees)), part2(deepcopy(trees))
    end

    function main()
        p1, p2 = solve()
        println("Part 1: $(p1)") # 33670
        println("Part 2: $(p2)") # 4903
    end

    main()
end
