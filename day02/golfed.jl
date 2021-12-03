t=Dict("up"=>(v,a,d,h)->(a-v,d,h),"down"=>(v,a,d,h)->(a+v,d,h),"forward"=>(v,a,d,h)->(a,d+a*v,h+v))
a=d=h=0
for c in map(split,split(read("input.txt",String),"\n")[1:end-1])global(a,d,h)=t[c[1]](parse(Int8,c[2]),a,d,h)end
for i in[a,d] println(i*h)end
