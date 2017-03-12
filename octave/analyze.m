function S = analyze(X)
	S = [];
	for i = 1:size(X, 1)    # for each row of the matrix
    v = analyze_row_vec(X(i, :));
    if length(v) > 0
      S = [S; v];
    endif
	endfor
endfunction
