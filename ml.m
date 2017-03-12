1;

av = argv();
M = readdata(av{1});
F = readdata(av{2});

m_rows = size(M, 1);
f_rows = size(F, 1);

X = [M; F];
y = [zeros(m_rows, 1); ones(f_rows, 1)];

save('-V6', av{3}, 'X', 'y');
