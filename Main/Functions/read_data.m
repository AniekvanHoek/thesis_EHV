function [data_vec] = read_data(patient_nr)
% FUNCTION [data_vec] = read_data(patient_nr)
%
% Input:
% patient_nr:   Integer, patient number corresponding to column "Study_ID"
%
%
% Output:
% data_vec:     Data vector of common BA's in peripheral, portal, fecal
%               compartment
%

%% Prepare
addpath(genpath(pwd))
file = 'RAW_BA_periportfeces_without_portal_outliers.xlsx';
data = readmatrix(file);
data_p = data(:,1:67);
data_f = data(:,[1, 68:96]);
data_p(isnan(data_p)) = 25*1e-03; % Portal and Peripheral, making NaNs detection value
data_f(isnan(data_f)) = 1*1e-02; % Portal and Peripheral, making NaNs detection value, own chosen value

%% Make data vector
for it = 1:size(data,1)
    if data_p(it, 1) == patient_nr
        
        % Peripheral
        for j = 1:38
            data_vec(j) = data_p(it, j+1).*1e-03; % Conversion to micromol
        end
        
        % Portal
        for j = 1:25
            data_vec(j+38) = data_p(it, j+41).*1e-03;  % Conversion to micromol
        end
        
        % Fecal
    end
    
    if data_f(it,1) == patient_nr
        total_weight_feces = data_f(it,29)*1e3; % Changing grams to milligrams
        if data_p(it, 1) == 114
            total_weight_feces = 145.5882353 * 1e3;
        end
        
        for k = 1:27
            data_vec(k+63) = data_f(it, k+1).* total_weight_feces .*1e-06; %making feces values micromol in 24h for total weight
        end        
    end 
end

end
    