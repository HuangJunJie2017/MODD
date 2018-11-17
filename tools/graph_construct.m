function [edge]=graph_construct(img_index,img_feature,w_point,h_point)
k=2;
edge.w=zeros(w_point*h_point*4,1);
edge.end=zeros(w_point*h_point*4,2);
num=1;
for i=1:w_point
    for j=1:h_point
        if img_index(i,j)~=0
            w_temp=ones(4,1)*100;
            if(i<w_point)
            dif=reshape(img_feature(i,j,:)-img_feature(i+1,j,:),k,1);
            w_temp(1)=dif'*dif;
            end
            if(j<h_point)
            dif=reshape(img_feature(i,j,:)-img_feature(i,j+1,:),k,1);
            w_temp(2)=dif'*dif;
            end
            if(i<w_point)&&(j<h_point)
            dif=reshape(img_feature(i,j,:)-img_feature(i+1,j+1,:),k,1);
            w_temp(3)=dif'*dif;
            end
            if(i<w_point)&&(j>1)
            dif=reshape(img_feature(i,j,:)-img_feature(i+1,j-1,:),k,1);
            w_temp(4)=dif'*dif;
            end

            [~,ord]=sort(w_temp(:,1),'ascend');
            idx=zeros(4,1);
            idx(ord(1))=1;
            idx(ord(2))=1;
            if((i<w_point)&&(img_index(i+1,j)~=0)&&(idx(1)==1))
                edge.end(num,1)=img_index(i,j);
                edge.end(num,2)=img_index(i+1,j);
                edge.w(num,1)=w_temp(1);
                num =num+1;
            end
            if((j<h_point)&&(img_index(i,j+1)~=0)&&(idx(2)==1))
                edge.end(num,1)=img_index(i,j);
                edge.end(num,2)=img_index(i,j+1);
                edge.w(num,1)=w_temp(2);
                num =num+1;
            end
            if((i<w_point)&&(j<h_point)&&(img_index(i+1,j+1)~=0)&&(idx(3)==1))
                edge.end(num,1)=img_index(i,j);
                edge.end(num,2)=img_index(i+1,j+1);
                edge.w(num,1)=w_temp(3);
                num =num+1;
            end
            if((i<w_point)&&(j>1)&&(img_index(i+1,j-1)~=0)&&(idx(4)==1))
                edge.end(num,1)=img_index(i,j);
                edge.end(num,2)=img_index(i+1,j-1);
                edge.w(num,1)=w_temp(4);
                num =num+1;
            end
        end
    end
end
edge.num=num-1;
edge.w=edge.w(1:edge.num,:);
edge.end=edge.end(1:edge.num,:);