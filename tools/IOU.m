function res = IOU(r1,r2)
% r1 = [627,480,97,100];
% r2 = [627,487,97,93];
    %计算两个矩形框的IOU
    %输入两个矩形框rec1 rec2 =[x,y,w,h]
    %两矩形框的面积
    area1 = r1(3) * r1(4);
    area2 = r2(3) * r2(4);
    %重合区域的长宽
    w = min(r1(1) + r1(3), r2(1) + r2(3)) - max(r1(1), r2(1));
    h = min(r1(2) + r1(4), r2(2) + r2(4)) - max(r1(2), r2(2));
    if w>0&&h>0
        cross = w * h;
        res = cross / (area1 + area2 - cross);
    else
        res = 0;
    end
end