% Conditions: Single-lane, max speed:3 cells, cars slow down randomly

clf
clear all
%build the GUI
%define the plot button
plotbutton=uicontrol('style','pushbutton',...
'string','Run', ...
'fontsize',12, ...
'position',[100,400,50,20], ...
'callback', 'run=1;');
%define the stop button
erasebutton=uicontrol('style','pushbutton',...
'string','Stop', ...
'fontsize',12, ...
'position',[200,400,50,20], ...
'callback','freeze=1;');
%define the Quit button
quitbutton=uicontrol('style','pushbutton',...
'string','Quit', ...
'fontsize',12, ...
'position',[300,400,50,20], ...
'callback','stop=1;close;');
number = uicontrol('style','text', ...
'string','1', ...
'fontsize',12, ...
'position',[20,400,50,20]);

%CA setup
n=1000;%蔍nitialization
z=zeros(2,n);%number of cells
z1=z(1,:);
z2=z(2,:);
z1=roadstart(z1,200);%Assume 200cars on the road
z1(1)=5;
evlocation=1;
evfrontcar=2;
den=10;
z2=roadstart(z2,200);%Assume 200cars on the road
cells1=z1;
cells2=z2;
cells(1,:)=cells1;
cells(2,:)=cells2;
vmax3=3;
vmax2=2;
vemax=5;
v1=speedstart(cells1,vmax2,vmax3);
v1(1)=5;
v2=speedstart(cells2,vmax2,vmax3);
x=1;
memor_cells1=zeros(3600,n);
memor_v1=zeros(3600,n);
memor_cells2=zeros(3600,n);
memor_v2=zeros(3600,n);
imh=imshow(cells);%Display the image
set(imh, 'erasemode', 'none')

axis equal
axis tight
stop=0; %wait for a quit button push
run=0; %wait for a draw
freeze=0; %wait for a freeze
while (stop==0)
      if(run==1)
   
          %deal with the boarder Conditions, search for the first and last cars
          cellshd1=cells1;
          cellshd2=cells2;
     %     i=searchleadcar(cellshd1);
          a1=searchleadcar(cellshd1);
          b1=searchlastcar(cellshd1);
          a2=searchleadcar(cellshd2);
          b2=searchlastcar(cellshd2); 
          evlocation=searchevcar(cellshd1);
          evfrontcar=searchfrontcar(evlocation,cellshd1);%search for the first position occupied by a cars
      %    i=a1;
for j=b1:a1
    if cellshd1(j)==0
        continue;
    elseif cellshd1(j)==6;
        continue;
    elseif cellshd1(j)~=0 && cellshd2(j)~=0
        continue;
    else
        if j==a1
            d1=n-a1+b1-1;
        else
            k1=searchfrontcar(j,cellshd1);
            d1=k1-j-1;
        end
        if j>a2
            d2=n-j+b2-1;
            d3=j-a2-1;
        else
            k2=searchfrontcar(j,cellshd2);
            d2=k2-j-1;
            if j>b2
                k3=searchbackcar(j,cellshd2);
                d3=j-k3-1;
            else
                d3=n-a2+b2-1;
            end
        end
    end

   % Decide to speed up or slow down
   if (d1<cells1(j))&&(d2>cells1(j))&&(d3>2);
        cells2(j)=cells1(j);
        cells1(j)=0;
    elseif j==evfrontcar&&(d2>cells1(j))&&(d3>=1);
        cells2(j)=cells1(j);
        cells1(j)=0;
    end
end
      
      
      
      

          cellshd1=cells2;
          cellshd2=cells1;
     %     i=searchleadcar(cellshd1);
          a1=searchleadcar(cellshd1);
          b1=searchlastcar(cellshd1);
          a2=searchleadcar(cellshd2);
          b2=searchlastcar(cellshd2); 
      %    i=a1;
for j=b1:a1
    if cellshd1(j)==0
        continue;
    elseif cellshd1(j)~=0 && cellshd2(j)~=0
        continue;
    elseif j>=evlocation && j-evlocation<=den;%受应急车干扰区域不换道
        continue;
    elseif j<evlocation && n-evlocation+j<=den;
        continue;%%%%%%%%%%%%%%%%%%%%%%%%%%%受应急车干扰区域不换道
    else
        if j==a1
            d1=n-a1+b1-1;
        else
            k1=searchfrontcar(j,cellshd1);%k1表示所在车道前方车辆位置
            d1=k1-j-1;
        end
        if j>a2
            d2=n-j+b2-1;
            d3=j-a2-1;
        else
            k2=searchfrontcar(j,cellshd2);%k1表示目标车道前方车辆位置
            d2=k2-j-1;
            if j>b2
                k3=searchbackcar(j,cellshd2);%k3表示目标车道后方车辆位置
                d3=j-k3-1;
            else
                d3=n-a2+b2-1;
            end
        end
    end
    if (d1<cells2(j))&&(d2>cells2(j))&&(d3>2);
        cells1(j)=cells2(j);
        cells2(j)=0;
    end
end
          
          
          

          a1=searchleadcar(cells1);
          b1=searchlastcar(cells1);
      %    i=a1;
          z1=cells1;
          for i=b1:a1
              j=a1+b1-i;
              if cells1(j)==0
                  continue;
              end
              if j==a1
                  if j==evlocation
                      v1(j)=min(v1(j)+1,vemax);
                  else
                     % v1(j)=min(v1(j)+1,vmax); 
                      v1(j)=min(v1(j)+1,cells1(j));
                  end
                  d=n-a1+b1-1;
                  v1(j)=min(v1(j),d);
                 % v1(j)=randslow(v1(j));%不考虑应急车辆干扰
                  if j>=evlocation && j-evlocation<=den;
                      v1(j)=v1(j);
                   elseif j<evlocation && n-evlocation+j<=den;
                      v1(j)=v1(j);
                  else
                     v1(j)=randslow(v1(j)); 
                  end

                  new_v1=v1(j);
                  
                  
                  if j+new_v1>n
                      z1(j)=0;
                      z1(j+new_v1-n)=cells1(j);
                      v1(j)=0;
                      v1(j+new_v1-n)=new_v1; 
                      
                  else
                      z1(j)=0;
                      z1(j+new_v1)=cells1(j);
                      v1(j)=0;
                      v1(j+new_v1)=new_v1; 
                  end
              else
                  if j==evlocation
                      v1(j)=min(v1(j)+1,vemax);
                  else
                     % v1(j)=min(v1(j)+1,vmax);
                     v1(j)=min(v1(j)+1,cells1(j)); 
                  end
                  %v1(j)=min(v1(j)+1,vmax);
                  k=searchfrontcar(j,cells1);
                  d=k-j-1;
                  v1(j)=min(v1(j),d);
                  v1(j)=randslow(v1(j));
                  new_v1=v1(j);
                  z1(j)=0;
                  z1(j+new_v1)=cells1(j);
                  v1(j)=0;
                  v1(j+new_v1)=new_v1;                   
              end
          end
                  
          
         
           %边界条件处理，搜索首末车，控制进出，使用周期性边界条件,车道2更新位置和速度             
          a2=searchleadcar(cells2);
          b2=searchlastcar(cells2);   
       %   i=a2;
          z2=cells2;
          for i=b2:a2
              j=a2+b2-i;
              if cells2(j)==0
                  continue;
              end
              if j==a2
                  %v2(j)=min(v2(j)+1,vmax); 
                  v2(j)=min(v2(j)+1,cells2(j)); 
                  d=n-a2+b2-1;
                  v2(j)=min(v2(j),d);
                  v2(j)=randslow(v2(j));
                  new_v2=v2(j);
                  if j+new_v2>n
                      z2(j)=0;
                      z2(j+new_v2-n)=cells2(j);
                      v2(j)=0;
                      v2(j+new_v2-n)=new_v2; 
                      
                  else
                      z2(j)=0;
                      z2(j+new_v2)=cells2(j);
                      v2(j)=0;
                      v2(j+new_v2)=new_v2; 
                  end       
              else
                  %v2(j)=min(v2(j)+1,vmax); 
                  v2(j)=min(v2(j)+1,cells2(j)); 
                  k=searchfrontcar(j,cells2);
                  d=k-j-1;
                  v2(j)=min(v2(j),d);
                  v2(j)=randslow(v2(j));
                  new_v2=v2(j);
                  z2(j)=0;
                  z2(j+new_v2)=cells2(j);
                  v2(j)=0;
                  v2(j+new_v2)=new_v2; 
              end
          end          
          
          
  
          
          
          cells1=z1;
          cells2=z2;
          cells(1,:)=cells1;
          cells(2,:)=cells2;
          memor_cells1(x,:)=cells1;%record the speed and positions of cars
          memor_v1(x,:)=v1;
          memor_cells2(x,:)=cells2;
          memor_v2(x,:)=v2;         
          x=x+1;
          set(imh,'cdata',cells)%更新图像
     
          %update the step number diaplay
          pause(0.2);
         % stepnumber = 1 + str2num(get(number,'string'));
         stepnumber = 1 + str2double(get(number,'string'));
          set(number,'string',num2str(stepnumber))
      end
      if (freeze==1)
         run = 0;
         freeze = 0;
      end
      drawnow
end