function Y = reducefeatures(X)
	Y = [];
	for i = 1:size(X, 1)
		r = reduce_features_row_vec(X(i, :));  # reduce features of row i
		Y = [Y; r];
	endfor
endfunction
