function y=produce_data()
clear;
num1=input('请输入随机产生第一类样本数num1=')
u1 = [-2 -2]';
sigma1 = [1 0; 0 1];%协方差阵
r1 = mvnrnd(u1,sigma1,num1);
plot(r1(:,1),r1(:,2),'b.');
hold on;
num2=input('请输入第二类样本数num2=')
u2 = [2 2]';
sigma2= [1 0; 0 1];
r2 = mvnrnd(u2,sigma2,num2);
plot(r2(:,1),r2(:,2),'ro');
file=fopen('data.txt','w');
fprintf(file,'%8s %8s \r\n','feature1','feature2');
fprintf(file,'%8.5f %8.5f \r\n',r1');
fprintf(file,'%8.5f %8.5f \r\n',r2');
fclose(file);
type data.txt
