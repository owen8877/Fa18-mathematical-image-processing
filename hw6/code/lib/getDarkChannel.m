function output = getDarkChannel(I, avg_size)
    output = zeros(size(I) - [2 2 0]*avg_size);
    for channel = 1:size(I, 3)
        for i = 1:size(I, 1) - 2*avg_size
            for j = 1:size(I, 2) - 2*avg_size
                output(i, j, channel) = min(I(i:i+2*avg_size, j:j+2*avg_size), [], 'all');
            end
        end
    end
end