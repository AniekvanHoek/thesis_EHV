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

%% Data & Weights 
% Data vector
data_vec = read_data(214);
t_data = calculate_datavec_3(data_vec);
sumpt = sum(t_data, 'omitnan');

% Weights vector
weights_vec = ones(63,1);
weights_vec(63) = 100;

%% Boundaries (pas bij 2e keer doen!)
load('refined_result_MST.mat');
p0             = result.p_opt;

lb = struct2array(result.model_info.l);
ub = struct2array(result.model_info.h);

%% Pre-allocation of arrays
sumE = zeros(33,21);
model= zeros(73,21,33);
error2 = zeros(117,21,33);

parscan_F_pen = struct('sumE', sumE, 'model_vec', model, 'error', error2);

%% Perform scan
% Parfor to run simulations over a range of parameter values
parfor i = 1:length(p0)
   p_change = p0;
   fprintf("Starting parameter %i", i);
   
   p_range = ub(i) - lb(i)
   p_step = p_range/20
   p_try = lb(i):p_step:ub(i)
   
   for j = 1:21
       p_change(i) = p_try(j);
       display(p_change(i))
       try
           [error, model_vec] = CF_parscan(p_change, t_data, sumpt, weights_vec, result.model_info);
       catch
           fprintf('Something happened in parameter %d, iteration %d, skipped.\n', i,j);
       end
       
       sumE(i,j) = sum(abs(error));
       model(:,j,i) = model_vec; 
       error2(:,j,i) = error;
         
   end          
end    

parscan_F_pen.sumE = sumE;
parscan_F_pen.model = model;
parscan_F_pen.error = error2;

%% Saving 
fprintf("saving struct")
save(sprintf('parscan_F_pen%s', datestr(now, 'mm-dd')) ,'parscan_F_pen')

%%
if ~isempty(gcp('nocreate')) && cluster.NumWorkers>4
delete(gcp('nocreate'))
end

delete(pool);