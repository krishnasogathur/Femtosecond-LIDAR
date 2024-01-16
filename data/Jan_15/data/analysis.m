clc;clear;close;clc;

data = load('data_2024-01-15_17_26_12.871903_0.025hres_1.02dres.txt');
data=2.99792458*1e10*1e-12*data;
data = data-min(data);
plot(data)


averaged_data = mov_avg(data,30);

plot(averaged_data)


figure(2), plot(data,'.-')
ylabel('dist in m')
xlabel('index')
%0 to 90
% 134 to end

fprintf("\nfirst part mean: %.2f first part std: %.2f",[mean(data(1:200)) - mean(data(400:end)) , std(data(1:200))])
fprintf("\nsecond part mean: %.2f second part std: %.2f",[mean(data(200:400)) - mean(data(400:end)), std(data(200:400))])
fprintf("\nthird part mean: %.2f third part std: %.2f",[mean(data(400:end)) - mean(data(400:end)), std(data(400:end))])



% length(data) = 242; resolution = 0.01cm;
% total scan length = 2.42 cm. we required it to scan for 3 cm.