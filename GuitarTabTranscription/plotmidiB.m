function plotmidiB(x, y, holdflag, n)


if holdflag == 'h'
   hold;
else if holdflag == 'f'
        figure;
    else error('3rd input must be either <h> or <f>'); 
    end
end

if n > 6 || n < 1
   error('4th input is pattern style. 1 < n < 6'); 
end

patterns = ['x', 'o', '*', '+', 'd', '^'];
p = patterns(n);

plot(x, y, p);
xlabel('Midi Note #');
ylabel('Inharmonicity coefficient \beta');
end