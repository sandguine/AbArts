function [output,timeStamp] = calibration (var, wPtr)
% last modified on Febraury 10 2016 by Eva

timeStamp = zeros (length(var.positionsX),1);

for i =1:length(var.positionsX)
x = var.positionsX(i); 
y = var.positionsY(i);

timeStamp(i,1) = java.lang.System.nanoTime/1000000000;
displayCalibrationDot(var,wPtr,x,y);
WaitSecs(3);

end

showInstruction(wPtr,'instructions/waitEvalCal.txt'); 

output =  str2double(input('Repeat calibration? (0= no or 1 = yes) ','s'));