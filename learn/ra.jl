ENABLE_ECHO_INPUT = 0x0004
ENABLE_INSERT_MODE = 0x0020
ENABLE_LINE_INPUT = 0x0002
ENABLE_MOUSE_INPUT = 0x0010
ENABLE_PROCESSED_INPUT = 0x0001
ENABLE_QUICK_EDIT_MODE = 0x0040
ENABLE_WINDOW_INPUT = 0x0008
ENABLE_VIRTUAL_TERMINAL_INPUT = 0x0200

STD_INPUT_HANDLE = -10
mode = ENABLE_VIRTUAL_TERMINAL_INPUT
handle = ccall(:GetStdHandle, Int64, (Int32,), STD_INPUT_HANDLE)
ccall(:SetConsoleMode, Cint, (Int64, Int32), handle, mode)

randcolor() = rand.((1:255, 1:255, 1:255))
randcolormatrix() = map(x -> randcolor(), Matrix{Tuple{UInt8,UInt8,UInt8}}(undef, displaysize(stdout)))
color(str, c) = "\e[38;2;$(c[1]);$(c[2]);$(c[3])m$(str)\e[0m"


represent(m) = join(eachrow(m) |> collect .|> row -> map(n -> "\e[38;2;$(n[1]);$(n[2]);$(n[3])m█\e[0m", row) |> join, "\n")

#println(randcolormatrix() |> represent)

width = displaysize(stdout)[2]
stripe = repeat("█", width)
d = (0, 0, 0)
b = (85, 205, 252)
w = (255, 255, 255)
p = (247, 168, 184)
println(color(stripe, b))
println(color(stripe, p))
println(color(stripe, w))
println(color(stripe, p))
println(color(stripe, b))



function pog()
    flag = permutedims([
        d b b b p p p w w w p p p b b b d;
        d b b b p p p w w w p p p b b b d;
        d b b b p p p w w w p p p b b b d;
        d d b b b p p p w w w p p p b b b;
        d d b b b p p p w w w p p p b b b;
        d d b b b p p p w w w p p p b b b;
        d d b b b p p p w w w p p p b b b;
        d b b b p p p w w w p p p b b b d;
        d b b b p p p w w w p p p b b b d;
        d b b b p p p w w w p p p b b b d;
        d b b b p p p w w w p p p b b b d;
        b b b p p p w w w p p p b b b d d;
        b b b p p p w w w p p p b b b d d;
        b b b p p p w w w p p p b b b d d;
        b b b p p p w w w p p p b b b d d
    ])
    flag = hcat(flag, flag, flag, flag, flag)
    while true
        if bytesavailable(stdin) > 0
            c = read(stdin, Char)
            println(c)
            c == 'q' && break
        end
        flag = circshift(flag, (0, 1))
        println(represent(flag))
        sleep(1)
    end
end

pog()





