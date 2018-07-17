function [CSnames,CSposition,US_side,US_identity,CS_side_congr,CS_outcome_congr] = LoadRandList(session)

% last modified 15 Sept

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BASIC STRUCTURE OF THE STUDY

    % two pairs of CS (left and right) for two food outcomes


%------------  CS associated with outcome A ------------------

% CSplus predicting outcome A to the left with 70% outcome A left; 10%
% outcome A right; 10% outcome B left; 10% not outcome
CSpAL =               [31;31;31;31;31;31;31;31;31;31];% 31 = CS predicting outcome A (3) to the left (1)
USpAL_side =          [ 1; 1; 1; 1; 1; 1; 1; 2; 1; 0];% 1 = left; 2 = right; 0 = no outcome
USpAL_identity =      [ 3; 3; 3; 3; 3; 3; 3; 3; 4; 0];% 3 = outcome A; 0 = no outcome
CSpAL_side_congr =    [ 1; 1; 1; 1; 1; 1; 1;-1; 1;-1]; % side prediction congruency 1= side congruent; -1= opposite side; 0 = no reward
CSpAL_outcome_congr = [ 1; 1; 1; 1; 1; 1; 1; 1;-1;-1]; % outcome prediction congruency 1= outcome congruent; -1= the other outcome is displayed; 0 = no reward

% CSplus predicting outcome A to the right with 70% outcome A right; 10%
% outcome A left; 10% outcome B right; 10% not outcome
CSpAR =               [32;32;32;32;32;32;32;32;32;32]; % 32 = CS predicting outcome A (3) to the right (2)
USpAR_side =          [ 2; 2; 2; 2; 2; 2; 2; 1; 2; 0];% 1 = left; 2 = right; 0 = none
USpAR_identity =      [ 3; 3; 3; 3; 3; 3; 3; 3; 4; 0];% 3 = outcome A; 0 = no outcome
CSpAR_side_congr =    [ 1; 1; 1; 1; 1; 1; 1;-1; 1;-1]; % side preditction congruency 1= side congruent; -1= incongruent
CSpAR_outcome_congr = [ 1; 1; 1; 1; 1; 1; 1; 1;-1;-1]; % outcome preditction congruency 1= outcome congruent; -1= outcome incongruent

%------------  CS associated with outcome B ------------------

% CSplus predicting outcome B to the left with 70% outcome A left; 10%
% outcome A right; 10% outcome B left; 10% not outcome
CSpBL =               [41;41;41;41;41;41;41;41;41;41];% 31 = CS predicting outcome B (4) to the left (1)
USpBL_side =          [ 1; 1; 1; 1; 1; 1; 1; 2; 1; 0];% 1 = left; 2 = right; 0 = no outcome
USpBL_identity =      [ 4; 4; 4; 4; 4; 4; 4; 4; 3; 0];% 3 = outcome A; 0 = no outcome
CSpBL_side_congr =    [ 1; 1; 1; 1; 1; 1; 1;-1; 1;-1]; % side preditction congruency 1= side congruent; -1= incongruent
CSpBL_outcome_congr = [ 1; 1; 1; 1; 1; 1; 1; 1;-1;-1]; % outcome preditction congruency 1= outcome congruent; -1= incongruent

% CSplus predicting outcome B to the right with 70% outcome A right; 10%
% outcome A left; 10% outcome B right; 10% not outcome
CSpBR =               [42;42;42;42;42;42;42;42;42;42]; % 32 = CS predicting outcome B (4) to the right (2)
USpBR_side =          [ 2; 2; 2; 2; 2; 2; 2; 1; 2; 0];% 1 = left; 2 = right; 0 = none
USpBR_identity =      [ 4; 4; 4; 4; 4; 4; 4; 4; 3; 0];% 3 = outcome A; 0 = no outcome
CSpBR_side_congr =    [ 1; 1; 1; 1; 1; 1; 1;-1; 1;-1]; % side preditction congruency 1= side congruent; -1= opposite side; 0 = no reward
CSpBR_outcome_congr = [ 1; 1; 1; 1; 1; 1; 1; 1;-1;-1]; % outcome preditction congruency 1= outcome congruent; -1= incongruent


%------------  CS associated with no outcome ------------------

% CSminus predicts no outcome 70% of the time 20% outcome A to the left and
% 10 outcome B to the right
CSmA =                [50;50;50;50;50;50;50;50;50;50]; % 50 CS predicting no outcome (5) to any side of the screen (0)
USmA_side =           [ 0; 0; 0; 0; 0; 0; 0; 1; 1; 2];% 1 = left; 2 = right; 0 = none
USmA_identity =       [ 0; 0; 0; 0; 0; 0; 0; 3; 3; 4];% 3 = outcome A; 4 = outcome B; 0 = no outcome
CSmA_side_congr =     [ 1; 1; 1; 1; 1; 1; 1;-1;-1;-1]; % prediction congruency 1 = congruent no reward, -1 = unexpected reward
CSmA_outcome_congr =  [ 1; 1; 1; 1; 1; 1; 1;-1;-1;-1];

% CSminus predicts no outcome 70% of the time 10% outcome A to the left and
% 20 outcome B to the right
CSmB =               [50;50;50;50;50;50;50;50;50;50]; % 50 CS predicting no outcome (5) to any side of the screen (0)
USmB_side =          [ 0; 0; 0; 0; 0; 0; 0; 1; 2; 2];% 1 = left; 2 = right; 0 = none
USmB_identity =      [ 0; 0; 0; 0; 0; 0; 0; 4; 4; 3];% 3 = outcome A; 4 = outcome B; 0 = no outcome
CSmB_side_congr =    [ 1; 1; 1; 1; 1; 1; 1;-1;-1;-1]; % prediction congruency 1 = congruent no reward, -1 = unexpected reward
CSmB_outcome_congr = [ 1; 1; 1; 1; 1; 1; 1;-1;-1;-1];

% All CSs appears 50% up and 50% down
CSposition =         [ 1; 1; 1; 1; 1; 2; 2; 2; 2; 2]; % 1= up; 2 = down

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONCATENATE 

CSnames = [CSpAL;CSpAR;CSpBL;CSpBR;CSmA;CSmB];
CSposition = [CSposition;CSposition;CSposition;CSposition;CSposition;CSposition];
US_identity = [USpAL_identity; USpAR_identity; USpBL_identity; USpBR_identity; USmA_identity; USmB_identity];
US_side = [USpAL_side; USpAR_side; USpBL_side; USpBR_side; USmA_side; USmB_side];
CS_side_congr = [CSpAL_side_congr; CSpAR_side_congr; CSpBL_side_congr; CSpBR_side_congr;CSmA_side_congr;CSmB_side_congr];
CS_outcome_congr = [CSpAL_outcome_congr;CSpAR_outcome_congr;CSpBL_outcome_congr;CSpBR_outcome_congr;CSmA_outcome_congr;CSmB_outcome_congr];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RESTRICT RANDOMIZATION TO HAVE CONGRUENT TRIALS IN THE BEGINING AND NO MORE THAN 3 CONSECUTIVE REPETITIONS


congr = nan (length(CS_outcome_congr),1); % initialized vector
for ii = 1: length(CS_outcome_congr)
    if CS_outcome_congr (ii) == 1 && CS_side_congr (ii) == 1
        congr(ii) = 1;
    else
        congr(ii) = -1;
    end
end % general congruency side and outcome


% data
randomIndex = randperm(length(CSnames)); %initial random index (there is no check of consecutive repetition here)
seq = CSnames(randomIndex)'; % intitial shuffle of the CS condition
seq_2 = congr (randomIndex)'; % no more

% engine repetitions
i = find(diff(seq));
n = [i numel(seq)] - [0 i];
c = arrayfun(@(X) X-1:-1:0, n , 'un',0);
y = cat(2,c{:}); % here you get the number of reptition of each element of the sequence of interest

% engine congruency
if session == 1
    ntrial = 10;
else
    ntrial = 1;
end

first_10 = seq_2 (1:ntrial);

% here we shuffle until there will be no more than 3 consecutives repetitions
while  ~isempty (find(y > 2, 1)) || ~isempty (find(first_10 < 0, 1))
    
    randomIndex = randperm(length(CSnames));
    seq = CSnames(randomIndex)'; % no more three repetitions in a row
    seq_2 = congr (randomIndex)'; % first 10 congruents
    
    % engine repetition
    i = find(diff(seq));
    n = [i numel(seq)] - [0 i];
    c = arrayfun(@(X) X-1:-1:0, n , 'un', 0);
    y = cat(2,c{:});
    
    % engine congruency
     first_10 = seq_2 (1:ntrial);
    
end

CSnames = CSnames (randomIndex);
CSposition = CSposition(randomIndex);
US_identity  = US_identity  (randomIndex);
US_side = US_side (randomIndex);
CS_side_congr = CS_side_congr (randomIndex);
CS_outcome_congr = CS_outcome_congr(randomIndex);