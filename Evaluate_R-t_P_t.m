%% 
%P-t_{iou} 和 R-t_{iou}曲线
%%
clear all
close all
addpath tools

nn=[2000,1250,3400,7400,2050,1099,1199,1200,3900,2750];
color={'r-','g-','b-','c-','y-','k-','b:','g:','y:','r:'};
successrate_total=zeros(50,10);
precision_total=zeros(50,10);

num_total_gt=0;
num_total_det=0;
for r=1:10
    ours=load(sprintf('result_confidence/%02d',r));%[frame_id, f_score, x, y, w, h]
    ours = ours.detect_box;
    gt=load(sprintf('gt_no_static/gt%02d',r));%[frame_id, 0, x, y, w, h]
    gt=gt.gt;
    result_ours=zeros(size(ours,1),1);%[iou] 默认值为[0]
    result_gt=zeros(size(gt,1),1);%[iou] 
    for i=1:nn(r)
        idx = find(gt(:,1)==i);
        n_gt = size(idx,1);
        rec_gt=zeros(n_gt,6);
        for j =1:n_gt
            rec_gt(j, :) = gt(idx(j), :);
            rec_gt(j, 2) = idx(j);
        end
        idx = find(ours(:,1)==i);
        n_ours = size(idx,1);
        rec_ours=zeros(n_ours,6);
        for j=1:n_ours
            rec_ours(j,:)= ours(idx(j),:);
            rec_ours(j,2)=idx(j);
        end
        if n_gt~=0&&n_ours~=0
            %计算相关矩阵r
            r_matrix = relation_compute(rec_ours,rec_gt);
            %KM算法要求输入的相关矩阵的维度[m,n]满足 m<=n
            transpose = false;
            if n_gt<n_ours
                transpose =true;
                r_matrix=r_matrix';
            end
            %使用KM算法求匹配
            match = KM(r_matrix);
            %根据匹配结果 match 和相关矩阵 r_matrix 给result_gt 和 result_ours 赋值
            if transpose
                r_matrix = r_matrix';
            end
            for rec = 1 : size(match,1)
                if transpose
                    gt_id_tmp = rec;
                    ours_id_tmp = match(rec);
                else
                    ours_id_tmp = rec;
                    gt_id_tmp = match(rec);
                end
                result_gt(rec_gt(gt_id_tmp, 2)) = r_matrix(ours_id_tmp, gt_id_tmp);
                result_ours(rec_ours(ours_id_tmp, 2)) = r_matrix(ours_id_tmp, gt_id_tmp);
            end
        end
    end
    successrate=zeros(50,1);
    for i=1:50
        iou=0.02*i;
        successrate(i)=sum(result_gt>iou);
    end
    successrate_total(:,r)=successrate;
    successrate=successrate/size(gt,1);
   
    num_total_gt=num_total_gt+size(gt,1);
    num_total_det = num_total_det+size(ours,1);
    precision=zeros(50,1);
    for i=1:50
        iou=0.02*i;
        precision(i)=sum(result_ours>iou);
    end
    precision_total(:,r)=precision;
    precision=precision/size(ours,1);
    
    x=0.02:0.02:1;
    figure(1)
    hold on
    plot(x,successrate,char(color(r)),'LineWidth',2.5);
    grid on
    hold off
    figure(2)
    hold on
    plot(x,precision,char(color(r)),'LineWidth',2.5);
    grid on
    hold off
end
successrate_final=sum(successrate_total,2)/num_total_gt;
precision_final=sum(precision_total,2)/num_total_det;
map=mean(successrate_final);
figure(3)
hold on
plot(x,successrate_final,'r','LineWidth',2.5);
plot(x,precision_final,'b','LineWidth',2.5);
xlabel('IoU threshold');
legend('Recall','Precision',3);
grid on
hold off


