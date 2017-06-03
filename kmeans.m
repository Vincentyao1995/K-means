%K-means 算法，输入参数t为自定义类别数目(中心数目)，取前t个样本作为初始中心。n为特征数目

% function y=kmeans(t,n,datafile_name)
% file=fopen(datafile_name,'r');
function kmeans(t)

%data中样本每行为一个样本，列为特征，n为特征数量。最后C1是个m*n的矩阵，m为样本数目。
%具体的textscan见help
%Delimiter后面的是指文件中每个数据用什么符号间隔开
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
    %将三维的数组格式转化一下，成为我写的数据格式。
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


%关于创建矩阵：http://blog.csdn.net/perfumekristy/article/details/8119861
Center=zeros(t,n);
%中心赋初值，不知道毛线 C_data(1:t,1:n)直接取为毛错了,因为C_data是cell类型的
for i=1:t
    for j=1:n
    Center(i,j)=C_data(i,j);
    end
end
temp_Center=ones(t,n);%用来做判断的，前后中心一致性问题。


%Num_samples=size(C_data,1);
D=zeros(Num_samples,t);

%创建分类数组,多维数组参考http://jingyan.baidu.com/article/5225f26b0a6650e6fa0908ea.html

class(:,:,:)=zeros(Num_samples,n,t);%每个类别中样本数最多是Num_samples,故肯定不会t个类别全占满的



%迭代开始了，先求距离，再分类，再求新类别的中心
judge=0;
temp_judge=0;
while judge==0%这里temp初值是ones.

%1.开始求距离,生成i j的矩阵，每行是一个点到t个中心各距离。
for i=1:Num_samples%求C_data的第1维大小
    for j=1:t
        a=C_data(i,:);
        b=Center(j,:);
        D(i,j)=sqrt((a-b)*(a-b)');
    end
end
%2.求距离并且分类
temp=ones(t,1);%每一类都需要一个temp来给他逐个样本写进去。
for i=1:Num_samples
    %备注：这里错了的话可以尝试D整体去求最小值，行列对应得转化一下。
    [M,I]=min(D(i,:)');%min求最小值是按列求的，故转置。
    %第i个样本， I就是其应属于的类别了    
    class(temp(I,1),:,I)=C_data(i,:);%给样本根据最小距离分类.
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
%3.求类中心均值了,变换中心了。
for i=1:t%i是类别号码
    temp_Center(i,:)=Center(i,:);%将旧的中心保存下来.
    Center(i,:)=mean(class(:,:,i));%mean是按列求的均值，生成了n个均值（各个特征的）1*n，这就是第i类的中心了
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
