
function time = AnticipationScreen(var,wPtr)

% Last modifed on 26 Jan 2015 by Eva

startT = GetSecs();

DrawnBaseScreen(var,wPtr);

Screen ('Flip', wPtr);

timer = GetSecs()-var.time_MRI;
while timer < var.ref_end
    timer = GetSecs()-var.time_MRI;
end

time = GetSecs()-startT;

end