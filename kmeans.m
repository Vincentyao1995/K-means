%K-means �㷨���������tΪ�Զ��������Ŀ(������Ŀ)��ȡǰt��������Ϊ��ʼ���ġ�nΪ������Ŀ

% function y=kmeans(t,n,datafile_name)
% file=fopen(datafile_name,'r');
function kmeans(t)

%data������ÿ��Ϊһ����������Ϊ������nΪ�������������C1�Ǹ�m*n�ľ���mΪ������Ŀ��
%�����textscan��help
%Delimiter�������ָ�ļ���ÿ��������ʲô���ż����
choice=input('Choose your data file type: \n1:txt  \n2:picture  \n');
%C_text=textscan(file,'%s',n,'Delimiter','')
if choice==1
%file=fopen('data.txt','r');
C_data=importdata('data.txt');
%C_data=cell2mat(C_data);
[Num_samples,n]=size(C_data);
%fclose(file);
end
if choice==2
 %   img=input('input your picture name');
    img='beijingcut.tif';
    C_data_temp=imread(img);
    %����ά�������ʽת��һ�£���Ϊ��д�����ݸ�ʽ��
    [rows,lines,deep]=size(C_data_temp);
    new_img=zeros(rows,lines);
    
    Num_samples=rows*lines;
    n=deep;
    for i=1:rows
        for j=1:lines
            for k=1:deep
                C_data((i-1)*lines+j,k)=C_data_temp(i,j,k);
            end
        end
    end
    C_data=double(C_data);
        
end
if choice~=1&&choice~=2
    disp('your input number is wrong, please reinput it!\n');
    return;
end


%���ڴ�������http://blog.csdn.net/perfumekristy/article/details/8119861
Center=zeros(t,n);
%���ĸ���ֵ����֪��ë�� C_data(1:t,1:n)ֱ��ȡΪë����,��ΪC_data��cell���͵�
for i=1:t
    for j=1:n
    Center(i,j)=C_data(i,j);
    end
end
temp_Center=ones(t,n);%�������жϵģ�ǰ������һ�������⡣


%Num_samples=size(C_data,1);
D=zeros(Num_samples,t);

%������������,��ά����ο�http://jingyan.baidu.com/article/5225f26b0a6650e6fa0908ea.html

class(:,:,:)=zeros(Num_samples,n,t);%ÿ������������������Num_samples,�ʿ϶�����t�����ȫռ����



%������ʼ�ˣ�������룬�ٷ��࣬��������������
judge=0;
temp_judge=0;
while judge==0%����temp��ֵ��ones.

%1.��ʼ�����,����i j�ľ���ÿ����һ���㵽t�����ĸ����롣
for i=1:Num_samples%��C_data�ĵ�1ά��С
    for j=1:t
        a=C_data(i,:);
        b=Center(j,:);
        D(i,j)=sqrt((a-b)*(a-b)');
    end
end
%2.����벢�ҷ���
temp=ones(t,1);%ÿһ�඼��Ҫһ��temp�������������д��ȥ��
for i=1:Num_samples
    %��ע��������˵Ļ����Գ���D����ȥ����Сֵ�����ж�Ӧ��ת��һ�¡�
    [M,I]=min(D(i,:)');%min����Сֵ�ǰ�����ģ���ת�á�
    %��i�������� I������Ӧ���ڵ������    
    class(temp(I,1),:,I)=C_data(i,:);%������������С�������.
    temp(I,1)=temp(I,1)+1;
    if choice==2
        new_rows=double(uint64(i/lines));
        new_lines=rem(i,lines);
        if(new_lines==0)
            new_lines=lines;
        end
        new_img(new_rows+1,new_lines)=255/5*(I-1);
    end
end
%3.�������ľ�ֵ��,�任�����ˡ�
for i=1:t%i��������
    temp_Center(i,:)=Center(i,:);%���ɵ����ı�������.
    Center(i,:)=mean(class(:,:,i));%mean�ǰ�����ľ�ֵ��������n����ֵ�����������ģ�1*n������ǵ�i���������
end


for i=1:t
    for j=1:n
        if Center(i,j)==temp_Center(i,j)
        temp_judge=temp_judge+1;
        end
    end
end
if temp_judge==n*t
    judge=1;
else
    temp_judge=0;
    judge=0;
end

end
imshow(new_img);
end
