n=100; %数据初始化
z=zeros(2,n); %元胞个数
z=roadstart(z,40); %道路状态初始化，路段上随机分布5辆
cells=z;
vmax=3; %最大速度
v=speedstart(cells,vmax); %速度初始化

cells1=cells(1,:);
cells1_new=cells(1,:);
cells2=cells(2,:);  
cells2_new=cells(2,:);
i=searchleadcar(cells1);
for j=1:i
    if cells1(i-j+1)==0;
        continue;
    else k1=searchfrontcar((i-j+1),cells1);%k1表示所在车道前方车辆位置
        k2=searchfrontcar((i-j+1),cells2);%k1表示目标车道前方车辆位置
        if k1==0;
            d1=n-(i-j+1);
        else d1=k1-(i-j+1)-1;%d1为所在车道前方车辆距离
        end
        if k2==0;
            d2=n-(i-j+1);
        else d2=k2-(i-j+1)-1;%d2为目标车道前方车辆距离
        end    
        if (d1<vmax)&(d2>vmax);
            cells1(i-j+1)=0;
            cells2(i-j+1)=1;
        else continue;
        end
    end
end
