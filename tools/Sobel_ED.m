function res = Sobel_ED( mat_input )
% clear all
% close all
% 
% mat_input(:,:,1) = [1,1,1;1,2,1;1,1,1];
% mat_input(:,:,2) = [1,1,1;1,2,1;1,1,1];
%使用Sobel算子求梯度模
[m,n,c]=size(mat_input);
if(m<3||n<3)
    error('assert failure: size of mat shold be large than 3*3!');
end
res = zeros(m,n);

for i=1:c
    mat = mat_input(:,:,i);
    m_t = [mat(1,:);mat(1:m-1,:)];
    m_lt = [m_t(:,1),m_t(:,1:n-1)];
    m_rt = [m_t(:,2:n),m_t(:,n)];

    m_d = [mat(2:m,:);mat(m,:)];
    m_ld = [m_d(:,1),m_d(:,1:n-1)];
    m_rd = [m_d(:,2:n),m_d(:,n)];

    m_l = [mat(:,1,:),mat(:,1:n-1,:)];
    m_r = [mat(:,2:n,:),mat(:,n,:)];

    res_h = 2*m_l+m_lt+m_ld-2*m_r-m_rt-m_rd;
    res_w = 2*m_t+m_lt+m_rt-2*m_d-m_ld-m_rd;
    res = res + abs(res_h)+abs(res_w);
end
res = sum(abs(res_h)+abs(res_w),3);
res = 1./(1+exp(-(res-1)*5));