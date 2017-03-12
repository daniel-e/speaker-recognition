1;

av = argv();
X = readdata(av{1});
save('-V6', av{2}, 'X');
