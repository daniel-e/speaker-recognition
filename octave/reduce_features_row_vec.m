# v is a row vector.
function r = reduce_features_row_vec(v)
	k = 10;
	r = [];
	for j = 1:k:length(v) - k
		r = [r, mean(v(j : j + k - 1))];
	endfor
endfunction
