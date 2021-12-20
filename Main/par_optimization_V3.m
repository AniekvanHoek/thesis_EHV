%% Prepare
addpath(genpath('/home/avhoek/BA_model_package')) %addpath(genpath(pwd)); %
close all; clearvars;

%% Load & Sort parameter sets
% Load
load('refined_result_MST.mat');
load('Results_Aniek/PE/V4/lhs_20p_10000samples_12-08_a.mat');


% Select proper ones
p_start = p_set.p_tweak(:,1:50);

% Location of parameters to tweak
p_loc= [3,9,11,13:20,22:28, 31,33];

% Upper and lower bounds
lb = [10, 0.00018, 400, 0.625, 0.9, 0.75, 0.75, 0.01, 0.5, 0.001, 0.005, 0.115, 0.0078, 0.00212, 0.1, 0.52, 0.002, 0.0005,  0.000001, 0.0000001];
ub = [55, 0.00088, 750, 0.75, 0.95, 0.85, 1, 1, 0.85, 0.01, 0.1, 0.18, 0.0105, 0.0034, 2.5, 0.68, 0.1, 0.1, 0.01, 0.00005];


%% Data vector
data_vec = read_data(214);
t_data = calculate_datavec_3(data_vec);
sumpt = sum(t_data(31:63), 'omitnan');

%% Weights vector
weights_vec = ones(63,1);
weights_vec(63) = 100; % fecal total is 100x less important



%% Optimization
N = 50

for i=1:N
    optionsfit = optimset('Display','iter', 'useParallel', true); %See iterations in command window %'MaxIter', iterations,

    costfun = @(p) CF_optimization_V3(p, p_loc, t_data, sumpt, weights_vec, result.model_info, result.p_opt); 
    display(costfun)
    
    [p_est, resnorm] = lsqnonlin(costfun, p_start(:,i),lb,ub,optionsfit);
    display(p_est)

    % Save 
    p_diff = ((p_est - p_start(:,i)) ./ p_start(:,i))*100;
    p_est_result(i).p_est = p_est;
    p_est_result(i).resnorm = resnorm;
    p_est_result(i).p_start = p_start(:,i);
    p_est_result(i).p_diff = p_diff;
    
    fprintf("saving")
    save(sprintf('opti_%dp', length(p_loc)) ,'p_est_result')
end
