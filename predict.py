#!/usr/bin/env python3

# requires scikit-learn 0.18+

from sklearn import svm
import scipy.io
import sys

d = scipy.io.loadmat(sys.argv[1])
X = d["X"]
y = d["y"].ravel()    # a 1d array is expected
print ("X.shape =", X.shape)

p = scipy.io.loadmat(sys.argv[2])
P = p["X"]
print ("P.shape =", P.shape)

clf = svm.SVC(kernel = 'rbf', class_weight = "balanced")
clf.fit(X, y);
r = list(clf.predict(P))
for c in sorted(set(r)):
    print ("class%d = %.3f (%d)" % (c, r.count(c) / len(r), r.count(c)))
