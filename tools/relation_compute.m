function res = relation_compute(ours,gt)
    %����gt��ours����boundingbox���ϵ���ؾ���
    %�����е�Ԫ��������boundingbox��IOU
    m = size(ours, 1);
    n = size(gt, 1);
    res = zeros(m,n);
    for i =1:m
        for j =1:n
            res(i,j) = IOU(ours(i,3:6),gt(j,3:6));
        end
    end
end