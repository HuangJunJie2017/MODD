function res = drawsmallrectangle(img,x,y,w,h,color)
res = img;
if color=='r'
    color_map = [255,0,0];
elseif color =='g'
    color_map = [0,255,0];
else 
    color_map = [255,255,0];
end

for i =x-w:x+w
    for j =0:2
        for k =1:3
            res(y-h+j,i,k) =color_map(k); 
            res(y+h-j,i,k) =color_map(k); 
        end
    end
end
for j =y-h:y+h
    for i =0:2
        for k =1:3
            res(j,x-w+i,k) =color_map(k); 
            res(j,x+w-i,k) =color_map(k); 
        end
    end
end

end