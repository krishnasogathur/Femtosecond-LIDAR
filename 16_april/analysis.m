%% Load data 
clc;clear;close;clc;
data_full = double(struct2array(load('can/10kHz_1sec_0.1sec_10ps/0.1cms-1_15cm_7cm.mat')));
bw = 10;

%% analysis part - pointwise estimator
data = data_full(3:10,20:130,1:300);
priori_depth = zeros(size(squeeze(data(:,:,1))));
priori_reflectivity = zeros(size(squeeze(data(:,:,1))));

for y = 1:length(squeeze(data(:,1,1)))
    for x = 1:length(squeeze(data(1,:,1)))
        point_hist = squeeze(data(y,x,:));

        % Apriori estimate: sample mean
        point_mean =  0;
        for j = 1:length(point_hist)
            point_mean = point_mean + j*point_hist(j);
        end
        point_mean = point_mean/sum(point_hist);
        
        priori_depth(y,x) = point_mean;
        priori_reflectivity(y,x) = mean(point_hist);
    end
    if rem(y,2)==0
        priori_depth(y,:) = flip(priori_depth(y,:));
    end
end

%% point based estimation using EMG
% Nonlinear estimator
% used desmos to graphically find shape parameter of our EMG by solving the
% equation given in dithered imaging paper. Used parameters from fitted
% distribution

% finding coefficients thru kurtosis matching:

p = 2.647; % shape parameter
% since shape param is less than 2 as such, we introduce uniform gaussian
% noise via dither so as to apply order statistics based estimation. ?

% order statistics:



% Processing - 2: weighted average mean estimator.
emg_estimator = zeros(size(squeeze(data(:,:,1))));
for y = 1:length(squeeze(data(:,1,1)))
   data_interest = squeeze(data(y,:,:));
   mean_time_array = zeros(length(data_interest(:,1)),1);
    
   for j = 1:length(data_interest(:,1))
        arr = data_interest(j,:);
        resolution = 1; %picosecond
        % order statistics:
        orderstats = []; %converts data to picosecond times
        for q = 1:length(arr)
            nr = arr(q); % number of times element q is repeated in array. goes into order statistics
            % x = double(not(not(nr)));
            for r = 1:nr
                orderstats = [orderstats q*resolution];
            end
        end
        orderstats = sort(orderstats);
        lenarr = length(orderstats);
    
        del = 1024;
        d = 0:del/lenarr:del-del/lenarr; %2ns data; each bin is shifted by x bins
    
        coeff = zeros(lenarr,1);
        %coefficients:
        for m = 1:lenarr/2
            denom = 0;
            for l = 1:lenarr/2
                denom = denom + (orderstats(lenarr - l + 1) - orderstats(l))^(p-2);
            end
            coeff(m) = 0.5*((orderstats(lenarr - m + 1) - orderstats(m))^(p-2) / denom);
            coeff(lenarr+1-m) = coeff(m);
        end
        coeff_real = real(coeff);
        coeff_imag = imag(coeff);
        coeff_abs = real(coeff);
        average = 0;
        for k = 1:length(orderstats)
            average = average + coeff_real(k)*(orderstats(k) + d(k));
        end
    
        mean_time_array(j) = average;
    end

   if rem(y,2)==0
       mean_time_array = flip(mean_time_array);
   end

   emg_estimator(y,:) = mean_time_array;
end


%% Distance analysis
c = 3e10;
priori_depth_dist = priori_depth*bw*1e-12*c / 2;
% priori_depth_dist = priori_depth_dist - mean(priori_depth_dist(1,100:140));

% emg_estimator_dist = emg_estimator*bw*1e-12*c / 2;
% emg_estimator_dist = emg_estimator_dist - mean(emg_estimator_dist(:,100:140),'all');

% object = zeros(size(priori_depth_dist));
% object(:,1:48) = 5.433 - 2.477;
% object(:,49:97) = 5.433;
% object(:,97:end) = 0;
% object = object + 0.5;


%% Data smoothening
matrix_2 = priori_depth_dist;

x_range = 25; y_range = 6;

% for xi = 1:length(matrix(:,1)) - x_range
%     for yi = 1:length(matrix(1,:)) - y_range 
%         matrix_2(xi,yi) = mean(priori_depth_dist(xi:xi+x_range,yi:yi+y_range) , "all");   
% 
%         if matrix_2(xi,yi) > 7(matrix_2(xi-1,yi) + matrix_2(xi+1,yi))/2/3;
%             matrix_2(xi,yi) = (matrix_2(xi-1,yi) + matrix_2(xi+1,yi))/2;
%         end
%     end
% end
% 
% 



%% Plotting

% matrix = priori_depth_dist(:,15:end);
matrix = matrix_2;
% matrix = priori_reflectivity;
% Get the size of the matrix
[rows, cols] = size(matrix);

% Create meshgrid for x and y coordinates
[x, y] = meshgrid(1:cols, 1:rows);

% Flatten matrix
z = matrix(:);
figure;
scatter3(x(:), y(:), z(:), 'filled');

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Scatter Plot of 2D Matrix');
