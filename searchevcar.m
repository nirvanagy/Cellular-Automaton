function  [location_evcar]=searchevcar(matrix_cells)
i=length(matrix_cells);
%if current_location==i
%   location_frontcar=0;
%else
    for j=1:i
       if matrix_cells(j)==6
          location_evcar=j;
       break;
       else
          location_evcar=0;
       end
    end