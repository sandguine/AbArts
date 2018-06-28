#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 28 10:30:23 2018

@authors: iman edited from sandy's code
"""

import requests
from bs4 import BeautifulSoup
import os
import sys
import urllib
import json
import re
import time

# Get current working directory
cwd = os.getcwd()
# Create a list of artworks styles wanted
styles = ['abstract-art', 'cubism', 'impressionism', 'color-field-painting']
# Create a list container for search result urls
searchresults = list()

# https://uploads5.wikiart.org/images/barnett-newman/moment-1946.jpg checkout this URL

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
        links = soup.find_all('script', type = "text/plain")

        # I'm not sure how to deal with JSON so I find another way around.
        # Simply look for patterns and grap the urls of pictures using regular expression.
        string = str(links)
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
