function R = readdata(file)
	# read file
	[F, fs, bits] = wavread(file);
	assert(fs == 44100, 'Require 44100 samples per second.');
	assert(size(F, 2) == 1, 'Only one channel is allowed.');
	# create a row vector
	A = F(:)';
	# select the first 120 seconds
	n = min([44100 * 120, length(A)]);
	A = A(1:n);
	# normalize; this helps a lot
	#A = A / max(A);
	R = reducefeatures(analyze(slidingwindows(A, 4410)));
endfunction
