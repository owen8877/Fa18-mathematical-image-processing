function mat = cell_to_mat(c)
    level = numel(c);
    basisN = size(c{1}, 1);
    shape = size(c{1}{1});
    
    mat = zeros(shape(1)*basisN*level, shape(2)*basisN);
    
    for i = 1:level
        mat((i-1)*shape(1)*basisN+1:i*shape(1)*basisN, :) = cell2mat(c{i});
    end
end