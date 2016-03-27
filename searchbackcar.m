function  [location_backcar]=searchbackcar(current_location,matrix_cells)
i=length(matrix_cells);
%if current_location==i
 %  location_backcar=0;
%else
 %   for j=current_location+1:i
  %     if matrix_cells(j)~=0
   %       location_backcar=j;
    %   break;
     %  else
      %    location_backcar=0;
      % end
    %end
%end


%if current_location==1
%    location_backcar=0;
    
%else
    j=current_location;
       for    k=1:(i-current_location+1)    
           if matrix_cells(j)~=0
               location_backcar=j;
               break;
           else
               location_backcar=0;
               j=j-1;
               if j==0
                   location_backcar=0;    
                   break;
               end  
           end
       end
%end

       
       
