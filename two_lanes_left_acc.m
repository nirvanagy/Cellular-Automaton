function [rho, flux,vmean,AIaver] = two_lanes_left_acc(rho, p, L,tmax,vmax)

% USAGE: flux = ns(rho, p, L, tmax, isdraw)
%        rho       = density of the traffic
%        p         = probability of random braking
%        L         = length of the load
%        tmax      = number of the iterations
%        animation = if show the animation of the traffic
%        spacetime = if plot the space-time after the simuation ended.
%        flux      = flux of the traffic

vmax =10;                  % maximun speed
vmin=0;
AI=[];
% place a distribution with density,initialization
ncar= round(L*rho);
rho = ncar/L;

XR= sort(randsample(1:L, ncar));
ROAD(1,1:L)=-1;
ROAD(2:3,1:L)=1;
ROAD(3,XR)=0;
ROAD(4,1:L)=-1;
%imshow(ROAD);
X=XR;
V=vmax*ones(1,ncar);   % start everyone initially at vmax


flux = 0;                  % number of cars that pass through the end
vmean = 0;
for t=1:tmax
 %------------------------------change OR NOT-----------------------%
    %overtake or not 
    %CarRO---the possible overtaking car
    %XRO --the possible overtaking position

%---RIGHT_overtake----%

    XR=find(ROAD(3,1:L)==0);%position with cars of right lane
    CarR=[];%car numbers on right
    for i=1:length(XR);
    c=find(X(1:end)==XR(i));
     CarR=[CarR c(1)];
    end
    VR=V(CarR);
    ncarR=length(CarR);%the number of car on right lanes
%1,neighbor cell on left lane is empty
   
    XRO1=ROAD(2,XR).*XR; %the possible overtaking position
    XRO2=XRO1(find(XRO1~=0));%the possible overtaking car
    CarRO1=[];
    for i=1:length(XRO2);
    c=find(X(1:end)==XRO2(i));
    CarRO1=[CarRO1 c(1)];
    end
 %2,Vn>Vn+1
    for i=1:length(CarR)
    if CarR(i)~=CarRO1(1:end)
        CarR(i)=0;
    end
    end
    VRO_get=VR-VR([2:end 1]);
    CarRO2=CarR.*(VRO_get>0);

%3,possiblity of overtaking  
    Poss=ones(1,ncarR);
    dv=VR./VR([2:end 1]);
    for i=1:ncarR
    if dv(i)==1;
       dv(i)=0.2;
    else dv(i)=max(0,min(0.8,0.4*dv(i)));
    end
    end
    Poss=Poss.*dv;
    W=rand(1,ncarR);
    CarRO3=CarRO2.*(W<Poss);
%4,gonna hit the car ahead on right lanes
    gapsR=gaplength(XR,L);
    CarRO4=CarRO3.*(gapsR<(VR+1));
%5,cannot hit the car before&behind on the left lanes 
    CarR_OJ=CarRO4(find(CarRO4~=0));
    ROAD(2,X(CarR_OJ))=0;%suppose the car has changed to left lanes
    XL_J=find(ROAD(2,1:L)==0);%position with cars of left lane
    CarL_J=[];%car numbers on left
    for i=1:length(XL_J);
       d=find(X(1:end)==XL_J(i));
     CarL_J=[CarL_J d(1)];
    end
    VL_J=[V(CarL_J)];
    gapsL_JA=gaplength(XL_J,L);%gaps with the car ahead
    if length(gapsL_JA)==0;
       gapsL_JB=[];
    else
      gapsL_JB=gapsL_JA([end 1:end-1]);%gaps with the car behind
    end
    Vmax_J=vmax.*ones(1,length(CarL_J));
    if length(CarL_J)~=0;
    CarL_J=CarL_J.*(gapsL_JA>VL_J).*(gapsL_JB>Vmax_J);%all cars qualied on the left
    end;
    for i=1:length(CarRO4)
    if CarRO4(i)~=CarL_J(1:end)
        CarRO4(i)=0;
    end
    end
    CarRO=CarRO4(find(CarRO4~=0));
    ROAD(2,X(CarR_OJ))=1;
    ROAD(2,X(CarRO))=0;
    ROAD(3,X(CarRO))=1;

%-----LEFT_change-----%
    XL=find(ROAD(2,1:L)==0);%position with cars of right lane
    CarL=[];%car numbers on left
    for i=1:length(XL);
       c=find(X(1:end)==XL(i));
       if length(c)==2;
         CarL=[CarL c(2)];
       else CarL=[CarL c(1)];
       end
    end
    VL=V(CarL);
    ncarL=length(CarL);%the number of car on right lanes
%1,neighbor cell on left lane is empty
   
    XLO1=ROAD(3,XL).*XL; %the possible overtaking position
    XLO2=XLO1(find(XLO1~=0));%the possible overtaking car
    CarLO1=[];
    for i=1:length(XLO2);
    c=find(X(1:end)==XLO2(i));
    CarLO1=[CarLO1 c(1)];
    end
%5,cannot hit the car before&behind on the left lanes 

    ROAD(2,X(CarLO1))=0;%suppose the car has changed to left lanes
    XR_J=find(ROAD(2,1:L)==0);%position with cars of left lane
    CarR_J=[];%car numbers on left
    for i=1:length(XR_J);
       d=find(X(1:end)==XR_J(i));
     CarR_J=[CarR_J d(1)];
    end
    VR_J=[V(CarR_J)];
    gapsR_JA=gaplength(XR_J,L);%gaps with the car ahead
    if length(gapsR_JA)==0;
       gapsR_JB=[];
    else
      gapsR_JB=gapsR_JA([end 1:end-1]);%gaps with the car behind
    end
    Vmax_J=vmax.*ones(1,length(CarR_J));
    if length(CarR_J)~=0;
       CarR_J=CarR_J.*(gapsR_JA>VR_J).*(gapsR_JB>Vmax_J);%all cars qualied on the left
    end
    for i=1:length(CarLO1)
    if CarLO1(i)~=CarR_J(1:end)
        CarLO1(i)=0;
    end
    end
    CarLO=CarLO1(find(CarLO1~=0));
    ROAD(3,X(CarR_OJ))=1
    ROAD(3,X(CarLO))=0;
    ROAD(2,X(CarLO))=1;
%-------------------------------GO AHEAED-----------------------------%
%--------------rignt lanes--------------------%
    XR=find(ROAD(3,1:L)==0);%position with cars of right lane
    CarR=[];%car numbers on left
    for i=1:length(XR);
       c=find(X(1:end)==XR(i));
     CarR=[CarR c(1)];
    end
    VR=V(CarR);
    Vmax=vmax.*ones(1,length(VR));
    Vmin=vmin.*ones(1,length(VR));  
    ncarR=length(CarR);
    if length(VR)~=0;
    VR=min(VR+1,Vmax);
    end;
%collision prevention
    gapsR=gaplength(XR,L); % determine the space vehicles have to move
     if length(VR)~=0;
    VR=min(VR,gapsR-1);
     end
% random speed drops
    VRdrops=(rand(1,ncarR)<p );
     if length(VR)~=0;
    VR=max(VR-VRdrops,Vmin);
     end;
% update the position
if length(VR)~=0
    if length(XR)~=0;
    XR=XR+VR;
    end
end
    passed=XR>L;          % cars passed at time r
    XR(passed)=XR(passed)-L;% periodic boundary conditions
    V(CarR)=VR;
    X(CarR)=XR;
    ROAD(3,1:L)=1;
    ROAD(3,XR)=0;

  %--------------left lanes--------------------%
     XL=find(ROAD(2,1:L)==0);%position with cars of right lane
    CarL=[];%car numbers on left
    for i=1:length(XL);
       c=find(X(1:end)==XL(i));
       if length(c)==2;
         CarL=[CarL c(2)];
       else  CarL=[CarL c(1)];
       end
     end
    VL=V(CarL);
    ncarL=length(CarL);
    Vmax=vmax.*ones(1,length(VL));
    Vmin=vmin.*ones(1,length(VL));
    if length(VL)~=0;
    VL=min(VL+1, Vmax);
    end;
%collision prevention
    gapsL=gaplength(XL,L); % determine the space vehicles have to move
    if length(VL)~=0;
    VL=min(VL,gapsL-1);
    end;
% random speed drops
VLdrops=(rand(1,ncarL)<p );
    if length(VL)~=0;
        VL=max(VL-VLdrops,Vmin);
    end
% update the position
if length(VL)~=0
    if length(XL)~=0;
    XL=XL+VL;
    end
end
    passed=XL>L;          % cars passed at time r
    XL(passed)=XL(passed)-L;% periodic boundary conditions
    V(CarL)=VL;
    X(CarL)=XL;
    ROAD(2,1:L)=1;
    ROAD(2,XL)=0;


%----------------------------SAFTY INDEX------------------------------%
vm=mean(V);
vs=std(V);
CarO=[CarLO CarRO];%numbers of overtaking cars
D=zeros(1,ncar);
D(CarO)=1;
Vsi=10*V;
Pacc=3*10^(-11)*25.76*exp(0.3196*vs)+5*10^(-9).*D.*(1-1/sqrt(2*pi)).*exp(-1/2*Vsi.^2)+10^(-9);
AS=((1/71)*Vsi).^4;
ai=sum(Pacc.*AS);
AI=[AI ai];
%------------------------------CACULATE------------------------------

 if t>tmax/2
        flux = flux + sum(V/L); %flux = flux + sum(passed); 
        vmean = vmean + mean(V);
 end

end
AIaver=mean(AI);
flux = flux/(tmax/2);
vmean = vmean/(tmax/2);

