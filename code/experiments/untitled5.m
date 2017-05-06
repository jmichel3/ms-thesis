x = ones(10000,1);

N = 100;
for i = 1:N
    
    tic;
    y = circshift(x,1);
    ~logical(sum(x-y))
    t1(i) = toc;

    tic;
    ~logical(range(x));
    t2(i) = toc;

    tic;
    ~logical(x-(sum(x)/length(x)));
    t3(i) = toc;
end

disp('circshift: ')
t1 = mean(t1)

disp('range: ')
t2 = mean(t2)

disp('avgdiff: ')
t3 = mean(t3)