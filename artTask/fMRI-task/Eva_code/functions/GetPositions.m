function var = GetPositions (ROIlt,ROIrb,cornerlt,cornerrb,screenXpixels,screenYpixels,var,rect)
%Last modified on January 29 2015 by Eva

[var.xCenter, var.yCenter] = RectCenter(rect);% Get the centre coordinate of the window

%%% for Experiment
var.squareXpos = [screenXpixels * ROIlt screenXpixels * ROIrb]; % Define horizontal ROIs position (0.25 0.75 were the original settings)
var.squareYpos = [screenYpixels * ROIlt screenYpixels * ROIrb]; % Define horizontal ROIs position
var.CSupper = screenYpixels * ROIlt;
var.CSlower = screenYpixels * ROIrb;
var.USleft = screenXpixels * ROIlt;
var.USright = screenXpixels * ROIrb;

%%% for Calibration
var.leftBottomX = screenXpixels *cornerlt;
var.leftBottomY = screenYpixels*cornerrb;
var.leftUpX = screenXpixels *cornerlt;
var.leftUpY = screenYpixels*cornerlt;
var.rightTopX = screenXpixels*cornerrb;
var.rightTopY = screenYpixels*cornerlt;
var.rightBottomX = screenXpixels*cornerrb;
var.rightBottomY = screenYpixels*cornerrb;


var.positionsNames = {'center'; 'leftBottom'; 'leftTop'; 'rightTop'; 'leftTop'; 'ROIleft'; 'ROItop'; 'ROIright';'ROIbottom'};
var.positionsX = [var.xCenter; var.leftBottomX; var.leftUpX; var.rightTopX;var.rightBottomX; var.USleft;var.xCenter;var.USright;var.xCenter];
var.positionsY = [var.yCenter; var.leftBottomY;var.leftUpY; var.rightTopY;var.rightBottomY; var.yCenter;var.CSupper;var.yCenter;var.CSlower];
end
