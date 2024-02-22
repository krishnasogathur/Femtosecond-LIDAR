n = 500:100:1500;

for i = n
    path = sprintf('power/%d',n);
    data = load('power/3000/*_1s.txt');

end
% % % 
% plot(mean(data,1));
% % % sum(data,'all');
% % 
% % 
% 
% n = 1:1:100;
% nonempty = zeros(size(n));
% 
% for i = 1:length(n)
% 
%     arr = data(i,:);
%     nonempty(i) = sum(arr>0);
% 
% end
% 
% plot(n,nonempty)
% 
% %figure(4); plot(mean(data(:,5300:5400),1),'o-')
figure(2); plot(mean(data,1));
% %figure(3);plot(mean(data,1)>0)
% 
