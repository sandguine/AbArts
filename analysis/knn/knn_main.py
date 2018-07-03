# Created July 2, 2018
# Iman Wahle
# KNN analysis on user-image ratings from MTurk study

from surprise import KNNWithZScore, KNNBasic, KNNWithMeans
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
NUM_NEIGHBORS = 200

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
sim_options = {'name': 'pearson_baseline', 'user_based': False}

# KNN types: http://surprise.readthedocs.io/en/stable/knn_inspired.html
algo = KNNWithZScore(k=NUM_NEIGHBORS, sim_options=sim_options)

# trainset, testset = train_test_split(data, test_size=.25)
# algo.fit(trainset)
# predictions = algo.test(testset)
# accuracy.rmse(predictions)

trainset = data.build_full_trainset()
algo.fit(trainset)





