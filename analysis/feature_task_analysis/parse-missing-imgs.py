#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  1 12:45:52 2019

@author: sandy
"""

import os, re
import pandas as pd

# change directory to where the file is
path = '/Users/sandy/Downloads/'
os.chdir(path)

# open file for parsing
file = open("trialdata.csv", "r")
text = file.read()

# prep for table
cat = pd.Series(['abstract', 'dynamic', 'temperature', 'valence'])
cat_list = list(cat.repeat(5))*7
raw_id = sorted(list(set(re.findall('debug\w+:debug\w+', text))))

# strip out only arts evaluation events
events = re.findall('debug\w+.*button_pressed.*untitled-\d{4}.*.jpg.*', text)

# create new array to keep the event
keep = []
for event in events:
    keep.append(re.findall('debug(\w+).*button_pressed"": ""(\d).*(untitled-\d{4}.*.jpg)', event))
keep = [sublist[0] for sublist in keep]

# generate pandas dataframe
df = pd.DataFrame(keep, columns=['raw_id', 'rating', 'img_name'])
df['categories'] = cat_list
df.to_csv('cleaned_missing_imgs.csv', index=False)


