n = 500:100:1500;
std_array = zeros(1,length(n));
mean_time_bin = zeros(1,length(n));

for i = 11 %1:length(n)
    j = 400 + 100*i;
    path = sprintf('power/%d/%.1fmW_200.0ps_1s.txt',j,40e-3*j);
    data = load(path);
    
    % %%% To check sigma vs N, expect a 1/sqrt(N) decrease if shot noise
    % max_array = zeros(1,length(data(:,1)));
    % for k = 1:length(max_array)
    %     max_array(k) = max(data(k,:));
    % end
    % std_array(i) = std(max_array);
    % %%%

    % %%% taking argmax bin of the averaged dataset as true value, and
    % %%% finding standard deviation of counts in this bin among 100 datasets
    % %%% at each power value
    % [maxval,bin_with_max_avg] = max(mean(data,1));
    % std_array(i) = std(data(:,bin_with_max_avg));

    %%% simply finding standard deviation in argmax value over 100 datasets
    bin_with_max = zeros(1,length(data(:,1)));
    maxval = zeros(1,length(data(:,1)));
    for m = 1:length(bin_with_max)
        [maxval(m), bin_with_max(m)] = max(data(m,:));
    end
    mean_time_bin(i) = mean(bin_with_max);
    std_array(i) = std(bin_with_max);
    %%% surprisingly enough no standard deviation observed over all
    %%% 100 datasets for each power value.
end

% fprintf("Mean of maximum counts in averaged array = %d\n",mean(maxvals))
% fprintf("variance = %d",(std(maxvals))^2)


% % some important figures to analyze
figure(1)
plot(mean(data,1));
title("Average data over 100 1 second acquisitions")

n = 1:1:100;
nonempty = zeros(size(n));

for i = 1:length(n)
    arr = data(i,:);
    nonempty(i) = sum(arr>0);
end

figure(2) 
plot(maxval);
title("maximum number of counts from each dataset")

figure(3)
plot(bin_with_max)
title("timestamp corresponding to max count from each dataset")
% figure(4); plot(mean(data(:,5300:5400),1),'o-') %around peak region
figure(4);plot(mean(data,1)>0) %shows distribution of nonempty bins across time histogram
title("Empty vs nonempty bins temporal distribution")
