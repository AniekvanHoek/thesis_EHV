%% Description
% This scripts runs 10000 Monte Carlo Simulations for parameter sets in
% which the parameters defined by p_loc are randomly distributed.
% Transformation rate constants are distributed uniformly over a log scale, whilst
% fractions are distributed uniformly over a normal scale.

%% Prepare
addpath(genpath('/home/avhoek/BA_model_package')) %addpath(genpath(pwd)); %addpath(genpath('/home/avhoek/BA_model_package')) %
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

%% Data vector
data_vec = read_data(214);
patient = calculate_datavec_3(data_vec);
sumpatient = sum(patient, 'omitnan');

%% Weights vector
weights_vec = ones(63,1);
weights_vec(63) = 100; % fecal total is 10x less important

%% Tweak parameter set
% Load initial parameters
load('refined_result_MST.mat')

p_loc= [3,9,11,13:20,22:28, 31,33]; % Locations of parameters (21 total)

% Tweak boundaries
lb = [10, 0.00018, 400, 0.625, 0.9, 0.75, 0.75, 0.01, 0.5, 0.001, 0.005, 0.115, 0.0078, 0.00212, 0.1, 0.52, log(0.002), log(0.0005),  log(0.000001), log(0.0000001)];
ub = [55, 0.00088, 750, 0.75, 0.95, 0.85, 1, 1, 0.85, 0.01, 0.1, 0.18, 0.0105, 0.0034, 2.5, 0.68, log(0.1), log(0.1), log(0.01), log(0.00005)];



% p_tweak matrix
N = 10000;
p_tweak = lhsdesign_modified(N,lb,ub); % Making random parameters
p_tweak(:,[17:20]) = exp(p_tweak(:, [17:20])); % Making log parameters normal again



%% Information to be printed
  fprintf('Monte Carlo simulation information:\n')
  fprintf('Number samples: %d\n', N)
  fprintf('LB are: [%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,%d, %d, %d, %d, %d, %d, %d, %d,%d, %d]\n', lb)
  fprintf('UB are: [%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,%d, %d, %d, %d, %d, %d, %d, %d,%d, %d]\n', ub)
  fprintf('Location of parameters tweaked are: [%d, %d, %d, %d, %d, %d, %d, %d, %d, %d,%d, %d, %d, %d, %d, %d, %d, %d,%d, %d]', p_loc) %, %d, %d, %d, %d, %d, %d, %d,% d, %d]', p_loc)


 %% Pre allocating vectors
 error = NaN(97,N);
 error_comp = NaN(32,N);
 sumE_all = NaN(N,1);
 sumE_comp = NaN(N,1);
 sumE_pen = NaN(N,1);
 model_vec = NaN(73,N);
 p_diff = NaN(33,N);
 
 % Struct
 p_set = struct('error', error, 'error_comp', error_comp, 'sumE_all', sumE_all, ...
     'sumE_comp', sumE_comp, 'sumE_pen', sumE_pen, 'model_vec', model_vec, 'p_diff', p_diff);
 
 %% Simulation loop
Ni = 5;
for s = 1:Ni
    parfor i=1+(N/Ni)*(s-1):(N/Ni)*s  
        p_temp = result.p_opt;
        p_temp(p_loc) = p_tweak(i,:);
        try 
            [error(:,i), model_vec(:,i)] = cost_function(p_tweak(i,:), p_loc, patient, sumpatient, weights_vec, result.model_info, result.p_opt); % Calculating cost function for patient 214
            p_diff(:,i) = ((p_temp - result.p_opt ) ./ result.p_opt )*100;
            i

        catch ME
            switch ME.identifier
                case 'MATLAB:UndefinedFunction'
                    warning('Function is undefined. Assigning a value of NaN.');
                    error(:,i) = NaN;
                    i
                

                case 'MATLAB:scriptNotAFunction'
                    warning(['Attempting to execute script as function. '...
                    'Running script and assigning output a value of 0.']);
                    notaFunction;
                    error(:,i) = NaN;
                    i
                otherwise
                    error(:,i) = NaN;
                    i
            end
        end
        
    end 
    
    % Save information in struct 
    p_set.error = error;
    p_set.error_comp = error(30:61,:);
    p_set.sumE_all = sum(abs(error));  
    p_set.sumE_comp = sum(abs(error(30:61,:)));
    p_set.sumE_pen = sum(abs(error(30:97,:)));
    p_set.model_vec = model_vec;
    p_set.p_tweak = p_tweak; 
    p_set.p_diff = p_diff;
    
    
    %save(sprintf('lhs_%dp_%dsamples_%s', length(p_loc),N, datestr(now, 'mm-dd_HHMM')) ,'p_set')
    fprintf("saving\n")
    save(sprintf('lhs_%dp_%dsamples_%s', length(p_loc),N, datestr(now, 'mm-dd')) ,'p_set')
end


%%
if ~isempty(gcp('nocreate')) && cluster.NumWorkers>4
delete(gcp('nocreate'))
end

delete(pool);

