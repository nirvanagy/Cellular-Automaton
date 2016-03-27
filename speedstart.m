function [v_matixcells]=speedstart(matrix_cells,vmax2,vmax3)
%道路初始装态车辆速度初始化
v_matixcells=zeros(1,length(matrix_cells));
for i=1:length(matrix_cells)
    if matrix_cells(i)~=0
       if matrix_cells(i)==2
           v_matixcells(i)=round(vmax2*rand(1));
       elseif matrix_cells(i)==3
        v_matixcells(i)=round(vmax3*rand(1));
       end
    end
end
       
        
