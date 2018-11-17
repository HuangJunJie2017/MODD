function res = check(b,w,h)
res = ones(4,1);
if b(1)<1
    res(1)=1;
else
    res(1)=ceil(b(1));
end

if b(2)<1
    res(2)=1;
else
    res(2)=ceil(b(2));
end

if b(1)+b(3)>w
    res(3)=floor(w -b(1));
else
    res(3)=floor(b(3));
end

if b(2)+b(4)>h
    res(4)=floor(h-b(2));
else
    res(4)=floor(b(4));
end

end