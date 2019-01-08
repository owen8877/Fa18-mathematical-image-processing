function y = soft_threshold(tau, v)
    y = sign(v).*max(abs(v)-tau,0);
end

