%% Preparation
addpath(genpath('/home/avhoek/BA_model_package')) %addpath(genpath(pwd))%
close all; clearvars;

%initialize cluster
cluster = parcluster('local');

%set number of workers (cores) to run
if cluster.NumWorkers>4
    n_work = cluster.NumWorkers-1;
else
    n_work = cluster.NumWorkers;
end

%initialize parallel pool, if it does not yet exist
if isempty(gcp('nocreate'))
    pool = parpool(cluster,n_work);
end

load('refined_result_MST.mat');
delta = 0.0001

%% Data & Weights 
% Data vector
data_vec = read_data(214);
t_data = calculate_datavec_3(data_vec);
sumpt = sum(t_data, 'omitnan');

% Weights vector
weights_vec = ones(63,1);
weights_vec(63) = 10; % fecal total is 10x less important


%% Initial results of simulations
p0             = result.p_opt;
[error_init, model_vec_init] = CF_sens(p0, t_data, sumpt, weights_vec, result.model_info);
SSE_init = sum(error_init.^2)

%% Pre allocation
SSE = zeros(33,1);
sens_SSE = zeros(33,1);
model_o = zeros(33,33);

sens = struct('SSE', SSE, 'sens_SSE', sens_SSE, 'sens_model', model_o);
%% Calculate new results

% Parfor to run simulations and calculate sensitivity of Cost Function
parfor i = 1:length(p0)
   p_change = p0;
   fprintf("Starting parameter %i", i);
   p_change(i) = p_change(i) * (1 + delta);
   display(p_change(i))
   try
       [error, model_vec] = CF_sens(p_change, t_data, sumpt, weights_vec, result.model_info);
   catch
       fprintf('Something happened in iteration %s, skipped.\n', i);
   end
   
   SSE(i) = sum(error.^2);
   sens_SSE(i) = ((SSE_init - SSE(i)) / SSE_init) / ((p0(i) - p_change(i))/p0(i));
   
   % Calculate sensitivity for all model outputs
   for j = 1:33
       model_o(i,j) = ((model_vec_init(j+30) - model_vec(j+30)) / model_vec_init(j+30)) / ((p0(i) - p_change(i))/p0(i));
   end
           
end          
    
%% Saving
sens.SSE = SSE;
sens.sens_SSE = sens_SSE;
sens.sens_model = model_o;

fprintf("saving struct")
save(sprintf('sens_%s', datestr(now, 'mm-dd')) ,'sens')


%%
if ~isempty(gcp('nocreate')) && cluster.NumWorkers>4
delete(gcp('nocreate'))
end

delete(pool);

