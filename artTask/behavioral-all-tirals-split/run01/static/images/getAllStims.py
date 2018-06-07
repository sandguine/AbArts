# -*- coding: utf-8 -*-
"""
Created on Tue Jun  4 19:39:43 2018

@author: sandy
"""

import glob, os, random, re

def getArtsNames(dirName):
    os.chdir(dirName)
    artList = []
    for file in glob.glob("*.jpg"):
        # print('{stimulus: \"img/' + dirName + '/' + file + '\"}, \n')
        artList.append(file)
    for file in glob.glob("*.bmp"):
        # print('{stimulus: \"img/' + dirName + '/' + file + '\"}, \n')
        artList.append(file)
    os.chdir("..")
    return artList

def getStims():
    allStims = []
    allVersions = [[] for i in range(1)]
    allArts = ["abstract", "colorFields", "cubism", "impressionism", "leslie"]
    
    for artStyle in allArts:
        artList = getArtsNames(artStyle)
        artList = random.sample(artList, len(artList))
        #artChunk = chunk(artList, numChunks)
        allStims.append(artList)
        
        for version in range(len(allVersions)):
            allVersions[version].append(artList[version])
            version += 1
    
    return allStims

allArtsAllVer = getStims()
beginStr = ' \'|\[\''
endStr = '\',|\']'
endReplace = '\"}, '

for style in range(len(allArtsAllVer)):
    if style == 0:
        abstractStr = str(allArtsAllVer[0])
        abstractStr = re.sub(beginStr, '{stimulus: \"static/images/abstract/', abstractStr)
        abstractStr = re.sub(endStr, endReplace, abstractStr)
        #print(abstractStr)
    elif style == 1:
        #print(allArtsAllVer[eachVersion][1])
        colorFieldsStr = str(allArtsAllVer[1])
        colorFieldsStr = re.sub(beginStr, '{stimulus: \"static/images/colorFields/', colorFieldsStr)
        colorFieldsStr = re.sub(endStr, endReplace, colorFieldsStr)
        #print(colorFieldsStr)
    elif style == 2:
        #print(allArtsAllVer[eachVersion][2])
        cubismStr = str(allArtsAllVer[2])
        cubismStr = re.sub(beginStr, '{stimulus: \"static/images/cubism/', cubismStr)
        cubismStr = re.sub(endStr, endReplace, cubismStr)
        #print(cubismStr)
    elif style == 3:
        #print(allArtsAllVer[eachVersion][3])
        impressionismStr = str(allArtsAllVer[3])
        impressionismStr = re.sub(beginStr, '{stimulus: \"static/images/impressionism/', impressionismStr)
        impressionismStr = re.sub(endStr, endReplace, impressionismStr)
        #print(impressionismStr)
    elif style == 4:
        leslieStr = str(allArtsAllVer[4])
        leslieStr = re.sub(beginStr, '{stimulus: \"static/images/leslie/', leslieStr)
        leslieStr = re.sub(endStr, endReplace, leslieStr)
            

toWrite = 'test_stimuli = [' + abstractStr 
toWrite = toWrite + colorFieldsStr 
toWrite = toWrite + cubismStr 
toWrite = toWrite + impressionismStr
toWrite = toWrite + leslieStr
toWrite = toWrite[:-2]
toWrite = toWrite + ']'

file = open("all.js", "w+")
file.write(toWrite)
file.close