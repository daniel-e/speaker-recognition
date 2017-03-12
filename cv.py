#!/usr/bin/env python3

# Loads the MATLAB file given as first argument which contains a matrix X
# and the target values in y.
# requires scikit-learn 0.18+

from sklearn.neighbors import KNeighborsClassifier
from sklearn import svm

from sklearn.model_selection import cross_val_score
import scipy.io
import sys

d = scipy.io.loadmat(sys.argv[1])
X = d["X"]
y = d["y"].ravel()    # a 1d array is expected

print ("X.shape =", X.shape)
for c in sorted(set(y)):
	print ("class%d = %d" % (c, list(y).count(c)))

classifiers = [
	(KNeighborsClassifier(n_neighbors = 5), "knn", "k=5"),
	(KNeighborsClassifier(n_neighbors = 9), "knn", "k=9"),
	(svm.SVC(kernel = 'linear', C = 1), "svm", "lin C=1"),
	(svm.SVC(kernel = 'poly', degree = 5), "svm", "poly degree=5"),
	(svm.SVC(kernel = 'rbf', class_weight = "balanced"), "svm", "rbf, gamma = 1/#rows")
]

print("\nacc  | std  | clf | parameters")
print("-----+------+-----+----------------------")
for clf, txt, par in classifiers:
	scores = cross_val_score(clf, X, y)
	print("%0.2f | %0.2f | %s | %s" % (scores.mean(), scores.std(), txt, par))

# ----

print("\nUsing X for training and classifying all examples of X ...")
clf = svm.SVC(kernel = 'rbf', class_weight = "balanced")
clf.fit(X, y)
for c in sorted(set(y)):
	indexes = [i for i in range(len(y)) if int(y[i]) == c]
	print("class %d examples (%d)" % (c, len(indexes)))
	t = list(clf.predict(X[indexes]))
	for j in sorted(set(t)):
		print("  classified as class %d = %.2f (%d)" % (j, t.count(j) / len(t), t.count(j)))
