function [t_data] = calculate_datavec_3(data_vec)
% FUNCTION [t_data] = calcule_datavec(datavec)
%
% Input:
% datavec:          Data vector loaded using the function read_datavec
%
% Output:
% Composition:      Absolute(1:20) and in percentages(30:49), 
%                   peripheral, portal and fecal compartment. 
%                   Per species and per group of species (primary/secondary)
%
% Conjugation:      Absolute(21:29) and in percentages(50:58), 
%                   peripheral, portal, fecal

%% Prepare
t_data = zeros(62,1);

%% Composition
%% Absolute
% Peripheral
% Sulfates are 29, 30, 31, 33, 34, 35, 36, 37
t_data(1) = sum(data_vec([4, 10, 17, 23, 29])); % CA
t_data(2) = sum(data_vec([6, 13, 20])); % CDCA
t_data(3) = sum(data_vec([7, 14 , 21, 24, 26 , 28, 30])); % DCA
t_data(4) = sum(data_vec([5, 11, 18, 25])); % UDCA
t_data(5) = sum(data_vec([8, 15, 22, 27])); % LCA
t_data(6) = data_vec(31); %LCAs
t_data(7) = sum(data_vec([1, 2, 3, 9, 12, 16, 19])); % other


% Portal
t_data(8) = sum(data_vec([40, 45, 50, 55, 56])); % CA
t_data(9) = sum(data_vec([41,46,51])); % CDCA
t_data(10) = sum(data_vec([42,47,52,58,59])); % DCA
t_data(11) = sum(data_vec([43,48,53,57])); % UDCA
t_data(12) = sum(data_vec([44,49,54])); % LCA
t_data(13) = NaN; % No LCAs
t_data(14) = data_vec(39); % other

% Fecal
t_data(15) = sum(data_vec([64,67,72,79,85])); % CA
t_data(16) = sum(data_vec([65,69,76])); % CDCA
t_data(17) = sum(data_vec([66,70,77,80,81,83,86,88])); % DCA
t_data(18) = sum(data_vec([68,74,82])); % UDCA
t_data(19) = sum(data_vec([71,78,84])); % LCA
t_data(20) = sum(data_vec([87,89])); % LCAs
t_data(21) = sum(data_vec([73,75])); % other


%% Conjugation
%% Absolute
% Peripheral
t_data(22) = (sum(data_vec(16:31))); %conj u
t_data(23) = (sum(data_vec(9:15))); %conj g
t_data(24) = (sum(data_vec(1:8))); %conj t

% Portal
t_data(25) = (sum(data_vec(50:59))); %conj u
t_data(26) = (sum(data_vec(45:49))); %conj g
t_data(27) = (sum(data_vec(39:44))); %conj t

% Fecal
t_data(28) = (sum(data_vec(72:89))); %conj u
t_data(29) = (sum(data_vec(67:71))); %conj g
t_data(30) = (sum(data_vec(64:66))); %conj t

%% Percentages 
total_peri = sum(data_vec(1:31));
total_por = sum(data_vec(39:59));

t_data(31:37) = t_data(1:7)./total_peri*100; %percentages with total of data
t_data(38:44) = t_data(8:14)./total_por*100; %percentages with total of data
t_data(45:51) = t_data(15:21)./data_vec(90)*100; %percentages with total of data

t_data(52:54) = t_data(22:24)./total_peri*100; % Peri conjugation %
t_data(55:57) = t_data(25:27)./total_por*100; % Portal conjugation %
t_data(58:60) = t_data(28:30)./data_vec(90)*100; % Fecal conjugation % 

%% Totals
t_data(61) = total_peri;
t_data(62) = total_por;
t_data(63) = data_vec(90);

end
    