function [conjugation, concentration] = conj_human_AvH(results_or_c, BAs, states, tissues, tag_fasting)
%  FUNCTION Calculations_Aniek/conj_human_AvH(results_or_c, BAs, states, tissues, equation, tag_fasting)
%
%
%  Description:
%   Calculate conjugation or equations thereof in any tissue, for input
%   list of bile acids
%
%  Inputs:
%   [1] results_or_c    - if equation == 1: model setup structure c
%                         if equation == 0: simulation results structure
%                         results
%   [2] BAs             - list (cell) of included BAs (or placeholder). 
%                         Note: without sulfates,
%                         these will be added later if necessary
%   [3] states          - list (cell) of included conjugation states (or
%                         placeholder)
%   [4] tissues         - tissue (cell) in which the composition should be
%                         assessed
%   [5] tag_fasting     - string to indicate location of fasting variables.
%                         e.g. 'results.fas.v.'
%
%  Outputs:
%   [1] conjugation     - calculated percentual conjugation or equations thereof
%                         (cell)
%   [2] concentration   - calculated absolute conjugation or equations thereof
%                         (cell)
%
%  Example: conjugation = conj_human(c, {{'CA'} {'CDCA'}}, {{'u'}, {'c'}}, {'li'}, 1, 'results.fas.v.')
%
%  Contact: Eindhoven University of Technology, F.L.P. Sips (f.l.p.sips@tue.nl)
%  Edited by A.E. van Hoek a.e.v.hoek@student.tue.nl
% 


%% Prepare
results = results_or_c;
equation = 0;

%% Perform replacements
[BA_list]           = eval_BA_list(BAs); 
[states_list]       = eval_states_list(states);
[tissue_list]       = eval_tissue_list(tissues); 


%% Calculate
conjugation     = cell(length(states_list),length(tissue_list));
concentration 	= cell(length(states_list),length(tissue_list));

for it = 1:length(tissue_list)
    curr_denominator  = 0;
    for is = 1:length(states_list)
        curr_numerator    = 0;

        for it_BA = 1:length(BA_list)
            
            curr_tissue = tissue_list{it};
            curr_BA     = BA_list{it_BA};
            curr_state  = states_list{is};


            for curr_BA_term = 1:length(curr_BA)
               % display(curr_BA_term)
                for state_BA_term = 1:length(curr_state)
                    curr_BA_term_eval       = curr_BA{curr_BA_term};
                    %display(curr_BA_term_eval)
                    curr_state_term_eval    = curr_state{state_BA_term};
                   % display(curr_state_term_eval)
                    curr_term               = eval_term(results, tag_fasting, curr_BA_term_eval, curr_tissue, curr_state_term_eval, equation);
                   % display(curr_term)
                    curr_numerator          = curr_numerator+curr_term;
                    curr_denominator        = curr_denominator+curr_term;
                   % display(curr_denominator)
                   % display(curr_numerator)
                end
            end

        end

        concentration{is, it} = curr_numerator;
        %fprintf('denominators are %d', denominators{it})
    end

    % Final assembly
    for is = 1:length(states_list)
        conjugation{is, it} = concentration{is, it}/curr_denominator*100;
    end
end
end

