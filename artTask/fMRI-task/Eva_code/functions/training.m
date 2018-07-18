function training(var,wPtr,CSname,CSposition,US_side,US_identity,bfm)

var.time_MRI = GetSecs();% this is just a temporary variable to execture the function here will be re written with the right value later
var.ref_end = 0;

for i = 1:2
    
    % define variables for this trial
    var.CSname = CSname(i);
    var.US_side = US_side(i);
    var.US_identity = US_identity(i);
    var.CSposition = CSposition(i);
    
    %%%%%%%%%%%%%%% Display CS JItter between 1.5 to 4.5  %%%%%%%%%%%%%%%%%
    tjietter = randsample([1.5:4.5,2:4],1);
    var.ref_end = var.ref_end + tjietter;
    DrawnCS(var,wPtr);
    
    %%%%%%%%%%%%%%% Display Anticipantion screens 3 s%%%%%%%%%%%%%%%%%%%%%%%%%
    var.ref_end = var.ref_end + 3;
    AnticipationScreen(var,wPtr);
    
    %%%%%%%%%%%%%%%%%%% Display US for 3s %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    var.ref_end = var.ref_end + 3; % attention here there is always a drift of going from 10 to 90 ms %unix format
    ShowUS(wPtr,var,bfm);

    %%%%%%%%%%%%%% Display ITI for 6s (jistter 4-8)%%%%%%%%%%%%%%%%%%%%%%%%
    tjietter = randsample([4.5:8,4:8],1);
    var.ref_end = var.ref_end + tjietter;
    data.durations.ITI(i,1) = DisplayITI (var,wPtr);

end