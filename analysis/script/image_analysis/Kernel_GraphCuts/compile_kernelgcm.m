% addpath 'D:\Dropbox\AbArts\analysis\script\image_analysis\GCMex'
 
% addpath 'C:\MinGW_53-master\bin'
% addpath('C:\MinGW_53-master\bin')
% addpath('C:\mingw-w64\i686-7.3.0-posix-dwarf-rt_v5-rev0\mingw32\bin')
 
 mex -g GraphCutConstr.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp

mex -g GraphCutMex.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp