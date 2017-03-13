from sklearn import svm
import scipy.io
import numpy as np

class Classifier:
    def __init__(self, model):
        d = scipy.io.loadmat(model)
        X = d["X"]
        y = d["y"].ravel()    # a 1d array is expected
        self.clf = svm.SVC(kernel = 'rbf', class_weight = "balanced")
        self.clf.fit(X, y);

    # predict a vector
    def predict(self, p):
        return int(self.clf.predict(np.matrix(p))[0])
