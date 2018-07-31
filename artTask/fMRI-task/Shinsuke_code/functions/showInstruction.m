function showInstruction(wPtr, instructionFile)

% Import the instructions from a file
instructionText = fileread(instructionFile);

% Screen settings
Screen('TextFont', wPtr, 'Arial');
Screen('TextSize', wPtr, 30);
Screen('TextStyle', wPtr, 1);

% Print the instruction on the screen
DrawFormattedText(wPtr, instructionText, 'center', 'center', [250 250 250], 60);
Screen(wPtr, 'Flip');

end