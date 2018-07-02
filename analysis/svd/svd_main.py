# Created June 29, 2018
# Iman Wahle
# SVD analysis on user-image ratings from MTurk study

from surprise import SVD
from surprise.model_selection import cross_validate
from surprise import Dataset
from surprise import Reader
from surprise.model_selection import train_test_split
from surprise import accuracy
from surprise.model_selection import GridSearchCV 

import scipy.io as sio
import numpy as np
import pandas as pd
#import matplotlib.pyplot as plt

NUM_USERS = 1545
NUM_IMAGES = 826

# loading data from mat file
mat_contents = sio.loadmat('ratings_list.mat')
data = np.array(mat_contents['X_list'])

# formatting for Surprise SVD package
ratings_dict = {
				'users' : data[:,0],
				'images' : data[:,1],
				'ratings' : data[:,2]
				} 
df = pd.DataFrame(ratings_dict)
reader = Reader(rating_scale=(0,3))
data = Dataset.load_from_df(df[['users', 'images', 'ratings']], reader)

algo = SVD(n_factors=20,n_epochs=40)

# Uncomment following sections individually to use
##################################################

# SVD with cross validation
#cross_validate(algo, data, measures=['RMSE', 'MAE'], cv=5, verbose=True)


# SVD with training on 75%, testing on 25%
# trainset, testset = train_test_split(data, test_size=0)
# algo.fit(trainset)
# predictions = algo.test(testset)
# accuracy.rmse(predictions)


# save feature matrices as mat files after training on whole data set
trainset = data.build_full_trainset()
algo.fit(trainset)
# need to convert from inner_id to raw_id
rawpu = [0 for i in range(NUM_USERS)]
rawqi = [0 for i in range(NUM_IMAGES)]
for i in trainset.all_users():
	rawpu[trainset.to_raw_uid(i)-1] = algo.pu[i]
for i in trainset.all_items():
	rawqi[trainset.to_raw_iid(i)-1] = algo.qi[i]
sio.savemat('user_svd_matrix', {'user_svd_matrix' :rawpu})
sio.savemat('image_svd_matrix', {'image_svd_matrix':rawqi})


# SVD grid search
# param_grid = { 	'n_factors': [20,40,60,80,100,120,140],
# 				'n_epochs' : [20,40,60]
# 		     }
# gs = GridSearchCV(SVD, param_grid, measures=['rmse','mae'],cv=5)
# gs.fit(data)
# print('best rmse, mae, and parameters: ')
# print(gs.best_score['rmse'])
# print(gs.best_score['mae'])
# print(gs.best_params['rmse'])
# print('all results: ')
# results_df = pd.DataFrame.from_dict(gs.cv_results)
# print(results_df)




