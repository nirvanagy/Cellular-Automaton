function [matrix_cells_start]=roadstart(matrix_cells,n)
%��·�ϵĳ�����ʼ��״̬��Ԫ���������Ϊ0��1,matrix_cells ��ʼ����n��ʼ������
k=length(matrix_cells);
z=round(k*rand(1,n));
for i=1:(n/2)
    j=z(i);
    if j==0 
       matrix_cells(j)=0;
    else
       matrix_cells(j)=2;
    end
end
for i=(n/2+1):n
    j=z(i);
    if j==0 
       matrix_cells(j)=0;
    else
       matrix_cells(j)=3;
    end
end
matrix_cells_start=matrix_cells;
