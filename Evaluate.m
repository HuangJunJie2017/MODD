%%
usage
%%
clear all
close all
addpath tools

%%
%-----------usage-------------
%save the result in the form the same to the example
%Spacify the method name for evaluation
%run the this demo
method = 'result_confidence';


%%
nums_frame=[2000,1250,3400,7400,2050,1099,1199,1200,3900,2750];
successrate_total=zeros(10,1);
precision_total=zeros(10,1);

%�趨��ͬ�ļ��Ҫ��
for iou_threshold = 0.3:0.1:0.7;
    
    for c = 1:21
        num_total_gt=0;
        num_total_det=0;
        confidence = c * 0.05-0.05;
        for r=1:10
            ours=load([method sprintf('/%02d',r)]);%[frame_id, f_score, x, y, w, h]
            ours = ours.detect_box;
            idx = find(ours(:,2)>=confidence);
            ours = ours(idx,:);
            gt=load(sprintf('gt_no_static/gt%02d',r));%[frame_id, 0, x, y, w, h]
            gt=gt.gt;
            result_ours=zeros(size(ours,1),1);%[iou] Ĭ��ֵΪ[0]
            result_gt=zeros(size(gt,1),1);%[iou] 
            for i=1:nums_frame(r)
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
                    %������ؾ���r
                    r_matrix = relation_compute(rec_ours,rec_gt);
                    %KM�㷨Ҫ���������ؾ����ά��[m,n]���� m<=n
                    transpose = false;
                    if n_gt<n_ours
                        transpose =true;
                        r_matrix=r_matrix';
                    end
                    %ʹ��KM�㷨��ƥ��
                    match = KM(r_matrix);
                    %����ƥ���� match ����ؾ��� r_matrix ��result_gt �� result_ours ��ֵ
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
            successrate=sum(result_gt>iou_threshold);
            successrate_total(r)=successrate;
            num_total_gt=num_total_gt+size(gt,1);
            num_total_det = num_total_det+size(ours,1);
            precision=sum(result_ours>iou_threshold);
            precision_total(r)=precision;
        end
        successrate_final(c)=sum(successrate_total)/num_total_gt;
        precision_final(c)=sum(precision_total)/num_total_det;
        false_positive_final(c)= num_total_det - sum(precision_total);
    end
    figure(1)
    hold on
    plot(successrate_final,precision_final,'color','r','LineWidth',1.5);
    hold off
    figure(2)
    hold on
    plot(false_positive_final,successrate_final,'color','r','LineWidth',1.5);
end
figure(1)
hold on
xlabel('Recall');
ylabel('Precision');
axis([0,1,0,1])
figure(2)
hold on
ylabel('True positive rate');
xlabel('False positives');
set(gca,'XTicklabel',{'0','5000','10000','15000','20000','25000'})

