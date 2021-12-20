function [error, model_vec] = cost_function(p, p_loc, patient, sumpatient, weights, info, opt)
p_fin = opt;
p_fin(p_loc) = p;
% Model vector
results = simulate(p_fin, info, 0); %Perform model simulation
fprintf("simulation is done")
model_vec = calc_model_vec(results);


%% Calculate error
% Component 1
error = ((patient - model_vec(1:63))./sumpatient)./weights; 
error = error(~isnan(error));


%% Penalties
% Component 2: fasting penalties
penalty = NaN(60,1);
for i = [1:4, 8:10, 22:28] %14 penalties
    if model_vec(i) < 0.1
        penalty(i) = 10;
    else
        penalty(i) = 0;
    end
end

for i = [31:34, 38:40, 47, 49, 58] %10 penalties
    if model_vec(i) < 1
        penalty(i) = 10;
    else
        penalty(i) = 0;
    end
end

for i = [35,36]
    if model_vec(i) > 8
        penalty(i+24) = 10;
    else
        penalty(i+24) = 0;
    end
end
    
penalty = penalty(~isnan(penalty));
    

%% Postprandial and transit checks
% Component 3: dynamic constraints

lower = [1.229304, 1.392784, 1, 0.6210001, 0.5421625, 0.5998976, 0, 30, 30, 20].';
upper = [13.316059, 17.944730, 3.774419, 6.919876, 11.736551, 2.161449, 120, 570, 570, 120].';

left = abs((model_vec(64:73)-((lower+upper)/2)));
right = abs(((upper/2) - (lower/2)));

error_dyn = max([left-right, zeros(10,1)], [],2);

%% Final
error = cat(1, error, penalty, error_dyn); %penalty,
        
end 
