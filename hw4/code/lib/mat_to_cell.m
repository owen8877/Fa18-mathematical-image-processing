function c = mat_to_cell(mat, basisN, level)
    c = cell(1, level);
    rowN = size(mat, 1) / level / basisN;
    colN = size(mat, 2) / basisN;
    for i = 1:level
        c{i} = mat2cell(mat(rowN*basisN*(i-1)+1:rowN*basisN*i, :), ...
            ones(1, basisN)*rowN, ones(1, basisN)*colN);
    end
end