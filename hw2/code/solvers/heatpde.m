function [f, clips] = heatpde(f, ~, ~, options)
    maxT = default(options, 'pde_maxTime', 10);
    dt = default(options, 'pde_dt', 0.5);
    boundCond = default(options, 'pde_boundary_condition', 'replicate');
    clipCount = default(options, 'solver_clip_count', 5);
    
    itr = 1;
    time = dt;

    shape = size(f); clips = zeros([shape(1) shape(2)*clipCount]);
    clipdt = maxT / clipCount - 1e-6; clipIndex = 0;
    while time <= maxT + 1e-6
        [fx, fy, fxx, fxy, fyy] = derivative(f, boundCond);
        f = f + dt * (fxx+fyy);
        
        if time >= (clipIndex+1)*clipdt
            clips(:, clipIndex*shape(2)+1:(clipIndex+1)*shape(2)) = f;
            clipIndex = clipIndex + 1;
        end

        itr = itr + 1;
        time = time + dt;
    end
end