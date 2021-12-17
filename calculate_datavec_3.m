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

%% Overige; weggedit zolang sulfation nog niet nodig is.

% %% Sulfation
% % Periphal
% t_data(57) = sum(data_vec(51:56)); %total unknown  Absolute
% % Percentages
% t_data(58) = data_vec(50) ./ total_sulf_pl * 100; % % LCAs
% t_data(59) = data_vec(48) ./ total_sulf_pl * 100; % % CAs
% t_data(60) = data_vec(49) ./ total_sulf_pl * 100; % % DCAs
% t_data(61) = t_data(65) ./total_sulf_pl * 100; % % unknowns
% 
% % Fecal
% t_data(62:66) = data_vec(57:61) ./ total_sulf_fa * 100; % percentages 

% Overige primary and secondary opgesplitst, getallen binnen t_data moeten
% opnieuw worden aangepast!!
% t_data(7) = (t_data(1) + t_data(2));%data_vec(1)+data_vec(6)+data_vec(11)+data_vec(2)+data_vec(7)+data_vec(12));%/all_peri*100; % Primary BAs CA and CDCA
% t_data(8) = t_data(3) + t_data(4)+t_data(5) + t_data(6); %(data_vec(3)+data_vec(8)+data_vec(13)+data_vec(4)+data_vec(9)+data_vec(14)+data_vec(5)+data_vec(10)+data_vec(15));%/all_peri*100; % Secondary BAs DCA, UDCA, LCA
% t_data(23) = sum(t_data(17:18)); %(data_vec(17)+data_vec(22)+data_vec(27)+data_vec(18)+data_vec(23)+data_vec(28));%/all_por*100; % Primary BAs CA and CDCA
% t_data(24) = sum(t_data(19:22)); %(data_vec(19)+data_vec(24)+data_vec(29)+data_vec(20)+data_vec(25)+data_vec(30)+data_vec(21)+data_vec(26)+data_vec(31));%/all_por*100; % Secondary BAs DCA, UDCA, LCA
% 
end
    