function y = norm1(x)



% max_vals = max(abs(notes),[],1); 
for i = 1:1:num_notes_valid
    notes(:,i) = notes(:,i)./max_vals(i);
end


end