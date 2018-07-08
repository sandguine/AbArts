#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul  7 12:01:55 2018

@author: sandy
"""

import os, re

# Global Variables

cwd = os.getcwd()
os.chdir(cwd)
#path = '/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/'
#os.chdir(path)
pattern = 'https?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+.jpg(?:!)'

ab = open("abstract.txt", 'r')
ab_str = ab.read()

cb = open("cubism.txt", 'r')
cb_str = cb.read()

cf = open("colorField.txt", 'r')
cf_str = cf.read()

im = open("impressionism.txt", 'r')
im_str = im.read()

ab_pictures = re.findall(pattern, ab_str)

cb_pictures = re.findall(pattern, cb_str)

cf_pictures = re.findall(pattern, cf_str)

im_pictures = re.findall(pattern, im_str)

list = [ab_pictures, cb_pictures, cf_pictures, im_pictures]

ab_txt = open("ab_pics", 'w')

for ab in ab_pictures:
  ab_txt.write("%s\n" % ab)

cb_txt = open("cb_pics", 'w')

for cb in cb_pictures:
  cb_txt.write("%s\n" % cb)

cf_txt = open("cf_pics", 'w')

for cf in cf_pictures:
  cf_txt.write("%s\n" % cf)

im_txt = open("im_pics", 'w')

for im in im_pictures:
  im_txt.write("%s\n" % im)




'''
for style in styles:
    # Append sub-directory name to full cwd path
    path = cwd + '/' + style
    # Create the sub-directory by style
    os.makedirs(path)

    # Create the full url name with style-name appened
    searchresult = "https://www.wikiart.org/en/paintings-by-style/" + style
    searchresults.append(searchresult)

    # Change working directory to the style sub-directory created
    os.chdir(path)

    # Let's get scrapin' baby!
    for searchresult in searchresults:
        # Request the content from the url
        r = requests.get(searchresult)
        # Get only the plain text component
        data = r.text
        # Parse it with through HTML parser
        soup = BeautifulSoup(data, 'html.parser')
    
        # Upon speculations (using print(soup.prettify()), the links of pictures were stored in JSON format.
        # The JSON of picture-urls is stored under <script> HTML tag. Let's grab it.
        
        # Simply look for patterns and grap the urls of pictures using regular expression.
        string = str(soup)
        pattern = 'https?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+.jpg'
        pictures = re.findall(pattern, string)

        # Well now, I got the urls in a list format. Let's download them all!!
        for picture in pictures:
            # Get the time stamp of current time
            timestamp = time.asctime()
            # Create file names
            txt = open('%s.jpg' % timestamp, "wb")
            # Link the url
            download_img = urllib.request.urlopen(picture)
            # Download it!
            txt.write(download_img.read())
            txt.close()
'''