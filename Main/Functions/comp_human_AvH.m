 function [composition, concentration, total] = comp_human_AvH(results_or_c, BAs, states, tissues, tag_fasting) %,conc
%  FUNCTION Calculations_Aniek/comp_human_AvH(results_or_c, BAs, states, tissues, equation, tag_fasting)
%
%  Description:
%   Calculate composition or equations thereof in any tissue, for input
%   list of bile acids
%
%  Inputs:
%   [1] results_or_c    - simulation results structure results
%   [2] BAs             - list (cell) of included BAs (or placeholder). 
%                         Note: without sulfates,
%                         these will be added later if necessary
%   [3] states          - list (cell) of included conjugation states (or
%                         placeholder)
%   [4] tissues         - tissue (cell) in which the composition should be
%                         assessed
%   [5] tag_fasting     - string to indicate location of fasting variables.
%                           e.g. 'results.fas.v.'
%   
%
%  Outputs:
%   [1] composition     - calculated composition or equation thereof
%                           (cell)
%   [2] concentration   - calculated concentration or equation thereof
%                           (cell)
%
%  Example: concentration = conc_human(c, {{'CA'}, {'CDCA'}, {'other'}, {'LCA'}}, {'all'}, {'po'}, 1, 'results.fas.v.')
%
%  Contact: Eindhoven University of Technology, F.L.P. Sips
%  (f.l.p.sips@tue.nl); Edited by A.E. van Hoek a.e.v.hoek@student.tue.nl
% 

%% Prepare
results = results_or_c;
equation = 0;

%% Perform replacements
[BA_list]           = eval_BA_list(BAs);
[states_list]       = eval_states_list(states);
[tissue_list]       = eval_tissue_list(tissues); 


%% Calculate
composition     = cell(length(BA_list), length(tissue_list));
concentration   = cell(length(BA_list), length(tissue_list));
total           = cell(length(tissue_list));

for it = 1:length(tissue_list)
    curr_denominator = 0;
    for ib = 1:length(BA_list)
        curr_numerator    = 0;

        for it_state = 1:length(states_list)

            curr_tissue = tissue_list{it};
            curr_BA = BA_list{ib};
            curr_state = states_list{it_state};


            for curr_BA_type_c = 1:length(curr_BA)
                for curr_state_type_c = 1:length(curr_state)
                    curr_BA_type        = curr_BA{curr_BA_type_c};
                    curr_state_type     = curr_state{curr_state_type_c};
                    curr_term           = eval_term(results, tag_fasting, curr_BA_type, curr_tissue, curr_state_type, equation);
                    curr_numerator   = curr_numerator + curr_term;
                    curr_denominator     = curr_denominator + curr_term;
                end
            end

        end

        concentration{ib, it} = curr_numerator;
    end

    % Final assembly
    total{it} = curr_denominator;
    for ib = 1:length(BA_list)
       composition{ib, it} = concentration{ib, it}/curr_denominator*100;
    end
end
end

