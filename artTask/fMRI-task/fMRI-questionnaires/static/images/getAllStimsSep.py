#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 08 18:03:13 2018

@author: sandy
"""

import glob, os, random, re

def getArtsNames(dirName):
    os.chdir(dirName)
    artList = []
    for file in glob.glob("*.jpg"):
        artList.append(file)
    for file in glob.glob("*.jpeg"):
        artList.append(file)
    for file in glob.glob("*.bmp"):
        artList.append(file)
    for file in glob.glob("*.png"):
        artList.append(file)
    os.chdir("..")
    return artList

def chunk(seq, num):
    avg = len(seq) / float(num)
    out = []
    last = 0.0
    while last < len(seq):
        out.append(seq[int(last):int(last + avg)])
        last += avg
    return out

numChunks = 10

def getStims():
    allStims = []
    allVersions = [[] for i in range(10)]
    allArts = ["abstract", "colorFields", "cubism", "impressionism", "leslie"]
    
    for artStyle in allArts:
        artList = getArtsNames(artStyle)
        artList = random.sample(artList, len(artList))
        artChunk = chunk(artList, numChunks)
        allStims.append(artChunk)
        
        for version in range(len(allVersions)):
            allVersions[version].append(artChunk[version])
            version += 1
    
    return allVersions

'''
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
'''

allArtsAllVer = getStims()
beginStr = ' \'|\[\''
endStr = '\',|\']'
endReplace = '\"}, '

for eachVersion in range(len(allArtsAllVer)):
    for style in range(5):
        if style == 0:
            abstractStr = str(allArtsAllVer[eachVersion][0])
            abstractStr = re.sub(beginStr, '{stimulus: \"static/images/abstract/', abstractStr)
            abstractStr = re.sub(endStr, endReplace, abstractStr)
            #print(abstractStr)
        elif style == 1:
            #print(allArtsAllVer[eachVersion][1])
            colorFieldsStr = str(allArtsAllVer[eachVersion][1])
            colorFieldsStr = re.sub(beginStr, '{stimulus: \"static/images/colorFields/', colorFieldsStr)
            colorFieldsStr = re.sub(endStr, endReplace, colorFieldsStr)
            #print(colorFieldsStr)
        elif style == 2:
            #print(allArtsAllVer[eachVersion][2])
            cubismStr = str(allArtsAllVer[eachVersion][2])
            cubismStr = re.sub(beginStr, '{stimulus: \"static/images/cubism/', cubismStr)
            cubismStr = re.sub(endStr, endReplace, cubismStr)
            #print(cubismStr)
        elif style == 3:
            #print(allArtsAllVer[eachVersion][3])
            impressionismStr = str(allArtsAllVer[eachVersion][3])
            impressionismStr = re.sub(beginStr, '{stimulus: \"static/images/impressionism/', impressionismStr)
            impressionismStr = re.sub(endStr, endReplace, impressionismStr)
            #print(impressionismStr)
        elif style == 4:
            leslieStr = str(allArtsAllVer[eachVersion][4])
            leslieStr = re.sub(beginStr, '{stimulus: \"static/images/leslie/', leslieStr)
            leslieStr = re.sub(endStr, endReplace, leslieStr)
            

    numVersion = eachVersion + 1
    numStr = str(numVersion)
    
    toWrite = 'test_stimuli_r' + numStr + ' = [' + abstractStr 
    toWrite = toWrite + colorFieldsStr 
    toWrite = toWrite + cubismStr 
    toWrite = toWrite + impressionismStr
    toWrite = toWrite + leslieStr
    toWrite = toWrite[:-2]
    toWrite = toWrite + ']'
    
    
    file = open("r" + numStr + ".js", "w")
    file.write(toWrite)
    file.close

    if eachVersion == 9:
        if style == 0:
            abstractStr = str(allArtsAllVer[eachVersion][0])
            abstractStr = re.sub(beginStr, '{stimulus: \"static/images/abstract/', abstractStr)
            abstractStr = re.sub(endStr, endReplace, abstractStr)
            #print(abstractStr)
        elif style == 1:
            #print(allArtsAllVer[eachVersion][1])
            colorFieldsStr = str(allArtsAllVer[eachVersion][1])
            colorFieldsStr = re.sub(beginStr, '{stimulus: \"static/images/colorFields/', colorFieldsStr)
            colorFieldsStr = re.sub(endStr, endReplace, colorFieldsStr)
            #print(colorFieldsStr)
        elif style == 2:
            #print(allArtsAllVer[eachVersion][2])
            cubismStr = str(allArtsAllVer[eachVersion][2])
            cubismStr = re.sub(beginStr, '{stimulus: \"static/images/cubism/', cubismStr)
            cubismStr = re.sub(endStr, endReplace, cubismStr)
            #print(cubismStr)
        elif style == 3:
            #print(allArtsAllVer[eachVersion][3])
            impressionismStr = str(allArtsAllVer[eachVersion][3])
            impressionismStr = re.sub(beginStr, '{stimulus: \"static/images/impressionism/', impressionismStr)
            impressionismStr = re.sub(endStr, endReplace, impressionismStr)
            #print(impressionismStr)
        elif style == 4:
            leslieStr = str(allArtsAllVer[eachVersion][4])
            leslieStr = re.sub(beginStr, '{stimulus: \"static/images/leslie/', leslieStr)
            leslieStr = re.sub(endStr, endReplace, leslieStr)
            

        numVersion = eachVersion + 1
        numStr = str(numVersion)
    
        toWrite = 'test_stimuli_r' + numStr + ' = [' + abstractStr 
        toWrite = toWrite + colorFieldsStr 
        toWrite = toWrite + cubismStr 
        toWrite = toWrite + impressionismStr
        toWrite = toWrite + leslieStr
        toWrite = toWrite[:-2]
        toWrite = toWrite + ']'
        
    
        file = open("r" + numStr + ".js", "w")
        file.write(toWrite)
        file.close