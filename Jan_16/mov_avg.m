function array2 = mov_avg(array,n)

array2 = [];

for i = 1:(length(array)-n)

    array3 = array(i:i+n);
    array2 = [array2; mean(array3)];

end

for i = length(array)-n+1:length(array)

    last_n = array(i:end);
    array2 = [array2 ;mean(last_n)];

end


end
