function time = getElTimestamp()

% returns the timestamp from the EyeLink based on John Palmer 7/19/02	created
% last modified on January 2017 

if Eyelink('RequestTime') ~= 0			% request time over network
    error('GetElTimestamp:  requesttime error');
end;
	
time = Eyelink ('ReadTime');		    % try and read time
while time == 0							% repeat until available
	time = Eyelink('ReadTime');	
end;
