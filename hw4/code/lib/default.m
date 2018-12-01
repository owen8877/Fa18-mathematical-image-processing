function value = default(s, key, def_value)
    if isfield(s, key)
        value = getfield(s, key);
    else
        value = def_value;
    end
end