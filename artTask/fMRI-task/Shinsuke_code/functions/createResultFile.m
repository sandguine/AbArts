function [resultFile, participantID,resultName] = createResultFile (session)
    % Ask the participand ID
    participantID = str2double (input ('Enter subject ID','s'));

    % Create the participant results file
    resultFile = (strcat('data/', 'PAV_fMRI_', num2str(participantID, '%02.0f'), '_',num2str(session),'.mat'));
    resultName = (strcat('P', num2str(participantID, '%02.0f'), '_',num2str(session)));

 
    % Check that the file does not already exist to avoid overwriting
    if exist(resultFile,'file')
        resp=questdlg({['The file ' resultFile ' already exists.']; 'Do you want to overwrite it?'},...
            'File exists warning','Cancel','Ok','Ok');
        
        if strcmp(resp,'Cancel') % Abort experiment if overwriting was not confirmed
            error('Overwriting was not confirmed: experiment aborted!');
        end
        
    end
    
end