clc;clear;close;clc;
data = load('2024-01-16_13_14_13.255354_0.025hres_1.02dres.txt');

data = data*1e-12*3*1e8;
data = data - min(data);

plot(data,'.-')

fprintf('total standard dev = %d',std(data));

data_smooth = mov_avg(data,20);

figure(2), plot(data,'.-')
ylabel('dist in m')
xlabel('index')
%0 to 90
% 134 to end

fprintf("\nfirst part mean: %.2f first part std: %.2f",[mean(data(1:54)), std(data(1:54))])
fprintf("\nsecond part mean: %.2f second part std: %.2f",[mean(data(63:end)), std(data(63:end))])
%fprintf("\nthird part mean: %.2f third part std: %.2f",[mean(data(588:end)), std(data(588:end))])



% length(data) = 242; resolution = 0.01cm;
% total scan length = 2.42 cm. we required it to scan for 3 cm.