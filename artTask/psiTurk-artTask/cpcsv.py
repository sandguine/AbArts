import glob, os, re

def read():
    cwd = os.getcwd()
    fileList = []
    for file in glob.glob("*.csv"):
        file = open(str(file), "r")
        fileList.append(file)
    return fileList

file  = glob.glob("[cv]*.js")
print file
