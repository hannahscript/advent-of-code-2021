d=map(l->parse(Int64,l),split(read("input.txt",String),"\n")[1:end-1])
p(x)=sum(map(((i,v),)->d[i]<v,enumerate(d[x:end])))
for i=1:2 println(p(i*2))end
