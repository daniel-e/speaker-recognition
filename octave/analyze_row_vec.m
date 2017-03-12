# Analyze the row vector r.
function v = analyze_row_vec(r)
  v = [];
	z = abs(fft(r));
	z = z(200:1200);
	if sum(z >= 1) > 20
    v = z;
	endif
endfunction
