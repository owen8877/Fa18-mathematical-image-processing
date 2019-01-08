function vn = normalizeFirst(v)
    v = v(:, :, 1);
    vn = v / sum(sum(v));
end