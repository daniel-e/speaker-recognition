# F needs to be a row vector.

function S = slidingwindows (v, l)
	S = [];
	for i = 1:441*5:length(v) - l + 1  # skip 50ms
		w = v(i:i + l - 1);              # select a window
		S = [S; w];
	endfor
endfunction
