%% Load data 
clc;clear;close;clc;
data_full = double(struct2array(load("modifiedsetup\0.5cms-1_1sec_14x10.mat")));
bw = 10;

%% analysis part - pointwise estimator
data = data_full;
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

%% Plotting

matrix = priori_depth_dist;
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
