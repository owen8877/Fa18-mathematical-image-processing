function vn = range01First(v)
    v = v(:, :, 1);
    vn = v / max(max(v));
end