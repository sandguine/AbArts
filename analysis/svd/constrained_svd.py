# Created July 16, 2018
# Iman Wahle
# Constrained SVD Algorithm:
# 	Given previously determined user feature matrix, 
# 	solve for image feature matrix with SGD


import scipy.io as sio
import numpy as np
from math import sqrt

NUM_USERS = 1545
NUM_IMAGES = 826
NUM_EPOCHS = 30
eta = 0.01
reg = 0.00

# calculate RMSE
def get_error():
	tot = 0;
	for d in range(len(data)):
		u = data[d][0]-1
		v = data[d][1]-1
		r = data[d][2]
		pred = 0
		for f in range(NUM_FEATS):
			pred += U[u][f]*V[v][f]
		
		tot += (r-pred)*(r-pred)
	tot /= len(data)
	return sqrt(tot)



# loading rating data from mat file
rating_contents = sio.loadmat('ratings_list.mat')
data = np.array(rating_contents['X_list'])
	
# loading set user feature matrix
given = sio.loadmat('../questionairre_analysis/survey_and_features.mat')
U = np.array(given['survey_and_features'])
# V = np.array(given['zpcfeats'])
NUM_FEATS = U.shape[1]
# NUM_FEATS = V.shape[1]
# initializing image feature matrix
# U = np.random.uniform(-.5,.5,(NUM_USERS, NUM_FEATS))
V = np.random.uniform(-.1,.1,(NUM_IMAGES, NUM_FEATS))

print(U.shape)
print(V.shape)
print(len(data))
print('should get (1545,), (826,), 87884')

print(get_error())
order = np.arange(len(data))
for epoch in range(NUM_EPOCHS):
	#eta *= 0.995
	np.random.shuffle(order)
	for d in order:
		u = data[d][0]-1
		v = data[d][1]-1
		r = data[d][2]

		pred = 0
		for f in range(NUM_FEATS):
			pred += U[u][f]*V[v][f]
		
		err = (r-pred)
		for f in range(NUM_FEATS):
			# print(V[v][f])
			# print(err*U[u][f])
			# print()
			uuf = U[u][f]
			# U[u][f] += eta*(err*V[v][f] - reg*U[u][f])
			V[v][f] += eta*(err*uuf - reg*V[v][f])
	print(get_error())

sio.savemat('constrained_image_svd_matrix', {'V' :V})





