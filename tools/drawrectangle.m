function res = drawrectangle(img,x,y,w,h,color)
res = img;
if color=='r'
    color_map = [255,0,0];
elseif color =='g'
    color_map = [0,255,0];
else 
    color_map = [255,255,0];
end

for i =x:x+w
    for j =0:1
        for k =1:3
            res(y+j,i,k) =color_map(k); 
            res(y+h-j,i,k) =color_map(k); 
        end
    end
end
for j =y:y+h
    for i =0:1
        for k =1:3
            res(j,x+i,k) =color_map(k); 
            res(j,x+w-i,k) =color_map(k); 
        end
    end
end

end