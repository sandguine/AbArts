function [matlab_time, UTC_date_time] = timeUnix2Matlab(unix_time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is not a real function, I did real quick to get a quick conversion

% convert unix_time to matlab_time
matlab_time = datenum([1970 1 1 0 0 unix_time]);

% convert matlab "now" in  year month day hour min sec and ms human
% readable format
UTC_date_time=datestr(matlab_time,'mmmm dd, yyyy HH:MM:SS.FFF AM');