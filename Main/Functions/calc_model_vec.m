function [model_vec] = calc_model_vec(results)
%  FUNCTION Calculations_Aniek/model_vec(results)
%
%  Description:
%   Make model_vector with absolute and relative values
%
%  Inputs:
%   [1] results         - structure of simulation results, where
%                         > results.fas.v contain all variables in the
%                           model in the fasting state
%
%  Outputs:
%   [1] model_vec       - Vector of 63 relative and absolute values 
%                         > 1:30 = absolute, 31:60 = percentual, 61:63 =
%                         totals
%  

%% Prepare
model_vec      = zeros(73,1);

%% Calculate from results structure
[comp, comp_conc, total] = comp_human_AvH(results, {{'all'}}, {{'all'}}, {{'pl'}, {'po'}, {'fa'}}, 'results.fas.v.');
[conj, conj_conc] = conj_human_AvH(results, {{'all'}}, {{'all'}}, {{'pl'}, {'po'}, {'fa'}}, 'results.fas.v.');

 
comp = cell2mat(comp);
comp_conc = cell2mat(comp_conc);
conj = cell2mat(conj);
conj_conc = cell2mat(conj_conc);
total = cell2mat(total);

%% Making model_vector
% Absolute data
% Composition
model_vec(1:7) = comp_conc(1:7,1); % Peripheral
model_vec(8:14) = comp_conc(1:7,2); % Portal
model_vec(15:21) = comp_conc(1:7,3); % Fecal

% Conjugation
model_vec(22:24) = conj_conc(1:3,1); % Peripheral
model_vec(25:27) = conj_conc(1:3,2); % Portal
model_vec(28:30) = conj_conc(1:3,3); % Fecal

% Percentual data
% Composition
model_vec(31:37) = comp(1:7,1); % Peripheral
model_vec(38:44) = comp(1:7,2); % Portal
model_vec(45:51) = comp(1:7,3); % Fecal

% Conjugation
model_vec(52:54) = conj(1:3,1); % Peripheral
model_vec(55:57) = conj(1:3,2); % Portal
model_vec(58:60) = conj(1:3,3); % Fecal

% Total
model_vec(61:63) = total(1:3);

% Postprandial
model_vec(64) = results.mea.y.max_all;

model_vec(65) = results.mea.y.max_conjugated;

model_vec(66) = results.mea.y.max_unconjugated;

model_vec(67) = results.mea.y.m30_all;

model_vec(68) = results.mea.y.m30_conjugated;

model_vec(69) = results.mea.y.m30_unconjugated;

model_vec(70) = results.mea.y.tom_all;

% Transit
model_vec(71) = results.transit.y.trans_sif;

model_vec(72) = results.transit.y.trans_sim;

model_vec(73) = results.transit.y.trans_co;

