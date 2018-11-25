function y = soft_threshold(tau, v, g)
%     y = 0*v;
%     y(v>tau) = v(v>tau) - tau;
%     y(v<-tau) = v(v<-tau) + tau;
    y = sign(v).*max(abs(v)-tau./g,0);
end

