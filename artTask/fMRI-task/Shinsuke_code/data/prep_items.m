function prep_items
%%
clear all; close all;

% get objective nutrition facts
data = xlsread('memo_nut_new.xlsx');
data_id_new = data(:,1);

save data_id_new data_id_new;

end