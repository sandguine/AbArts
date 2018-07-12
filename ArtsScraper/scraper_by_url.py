# Downloading better resolution images from list of website URLs
# Iman Wahle
# July 9 2018
from os import listdir
from os.path import isfile, join
import numpy as np
import urllib.request


categories = ['impressionism'] #['abstract', 'colorField', 'cubism']#, 'impressionism']

for category in categories:
	# get all names of currently saved images
	mypath = 'database/' + category
	only_files = [f for f in listdir(mypath) if isfile(join(mypath, f))]
	# load all URLs from website
	if category == 'abstract': cat = 'ab_pics'
	elif category == 'colorField': cat = 'cf_pics'
	elif category == 'cubism': cat = 'cb_pics'
	elif category == 'impressionism': cat = 'im_pics'
	else: print('error')
	all_urls = np.loadtxt(cat + '.txt', dtype='str', delimiter='\n')
	# find matching URL for each image
	urls_to_download = []
	corresponding_names = []
	num_image_matches = 0
	not_found = []
	for file_name in only_files: 
		found = False
		for url in all_urls:
			split_url = url.rsplit('/')
			name = split_url[-1]
			file_name = file_name.rsplit('PinterestLarge')[0]
			if file_name == name:
				found = True
				num_image_matches += 1
				urls_to_download.append(url)
				corresponding_names.append(name)
		if not(found):
			not_found.append(file_name)
	np.savetxt('not_found_' + category + '.txt', not_found, delimiter=',',fmt='%s')
	print('Number of matches found: ' + str(num_image_matches))
	# download images
	for i in range(len(urls_to_download)):
		url = urls_to_download[i]
		name = corresponding_names[i]
		urllib.request.urlretrieve(url.strip('!'), 'better_res_database/' + category + '/' + name.strip('!'))



