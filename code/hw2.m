%% Load %%
load sounds.mat

%% Input %%
num_sources = 4;
num_mics = 6;

mic_fig_x = 3;
mic_fig_y = 2;

%% Initialization %%
U = sounds(1:num_sources,:); % sources
nt = size(U); 

n = nt(1); % number of sources
t = nt(2); % number of values of each signal from times t=1 to t=t.
m = num_mics; % number of mics (each mic gets a mixed signal)

A = rand(m,n)*10;
X = A*U; % mixed signals

fig_num = 1;
Fs = 11025;
x_axis = (1:t)/Fs;

%% Algorithm %%
W = 0.001*rand(n,m);
eta = 0.01;
num_iters = 0;

while num_iters < 100000
    Y = W*X;
    Z = g(Y);
    dW = (eye(n) + ((1-2*Z)*Y')/t)*W;
    del_W = eta * dW;
    if del_W*X < 0.0001
        break;
    end
    W = W + del_W;
    num_iters = num_iters + 1;
end
fprintf('Number of iterations for convergence: %i\n', num_iters);

%% Rescale recovered signals %%
for i = 1:num_sources
Y(i,:) = rescale(Y(i,:),-1,1);
end

%% Correlation of Signals %%
corrs = corr(Y', U');
[max_corrs, ind] = max(abs(corrs));
Y = Y(ind,:);
save('corrs.mat', 'corrs');

%% Plot mixed signals %% 
figure(fig_num);
fig_num = fig_num + 1;
for i = 1:num_mics
subplot(mic_fig_x,mic_fig_y,i);
plot(x_axis,rescale(X(i,:), -1, 1),'m');
title(['Mixed Signal ', num2str(i)]);
end
 
%% Plot source and recovered signals %% 
figure(fig_num);
fig_num = fig_num + 1;
for i = 1:num_sources 
subplot(n,2,2*i-1);
plot(x_axis, U(i,:),'b');
title(['Source Signal ', num2str(i)]);

subplot(n,2,2*i);
plot(x_axis, Y(i,:),'r');
title(['Recovered Signal ', num2str(i)]);
end

%% Listen to mixed signals %%
for i = 1:num_mics
fprintf('Mixed Signal %i:\n', i);
listen(rescale(X(i,:), -1, 1));
pause(6);
end

%% Listen to source and recovered signals %%
for i = 1:num_sources
fprintf('Source Signal %i:\n', i);
listen(U(i,:));
pause(6);
fprintf('Recovered Signal %i:\n', i);
listen(Y(i,:));
pause(6);
end

%% Algorithm - effect of learning rate on correlation %%
% lr = [0.0001:0.0001:0.001, 0.002:0.001:0.01, 0.02:0.01:0.1, 0.2:0.1:1.0];
% num_lr = size(lr); num_lr = num_lr(2);
% corr_lr3m3 = zeros(num_lr, num_sources);
% for i = 1:num_lr
%     eta = lr(i);
%     W = 0.001*rand(n,m);
%     num_iters = 0;
% 
%     while num_iters < 350
%         num_iters = num_iters + 1;
%         Y = W*X;
%         Z = g(Y);
%         dW = (eye(n) + ((1-2*Z)*Y')/t)*W;
%         del_W = eta * dW;
%         if del_W*X < 0.0001
%             break;
%         end
%         W = W + del_W;     
%     end
%     fprintf('Number of iterations for convergence: %i\n', num_iters);
%     for j = 1:num_sources
%         Y(j,:) = rescale(Y(j,:),-1,1);
%     end
%     corrs = corr(Y', U');
%     [max_corrs, ind] = max(abs(corrs));
%     max_corrs = max_corrs(ind);
%     corr_lr3m3(i,:) = max_corrs;
% end
% figure(fig_num);
% fig_num = fig_num + 1;
% plot(lr, corr_lr3m3);
% axis([0 1 0 1.02]);
% legend('source 1', 'source 2', 'source 3', 'source 4', 'source 5');

%% Algorithm - effect of learning rate on convergence %%
% lr = [0.0001:0.0001:0.001, 0.002:0.001:0.01, 0.02:0.01:0.1, 0.2:0.1:1.0];
% num_lr = size(lr); num_lr = num_lr(2);
% num_iters_list = zeros(1,num_lr);
% for i = 1:num_lr
%     eta = lr(i);
%     W = 0.001*rand(n,m);
%     num_iters = 0;
% 
%     while num_iters < 8000
%         num_iters = num_iters + 1;
%         Y = W*X;
%         Z = g(Y);
%         dW = (eye(n) + ((1-2*Z)*Y')/t)*W;
%         del_W = eta * dW;
%         if del_W*X < 0.0001
%             break;
%         end
%         W = W + del_W;     
%     end
%     fprintf('Number of iterations for convergence: %i\n', num_iters);
%     num_iters_list(i) = num_iters;
% end
% save('num_iters_list.mat', 'num_iters_list');

%% Plot lr vs convergence%%
% lr = [0.0001:0.0001:0.001, 0.002:0.001:0.01, 0.02:0.01:0.1, 0.2:0.1:1.0];
% s2m3 = load('num_iters_list2m3.mat'); s2m3 = s2m3.num_iters_list;
% s2m4 = load('num_iters_list2m4.mat'); s2m4 = s2m4.num_iters_list;
% s3m3 = load('num_iters_list3m3.mat'); s3m3 = s3m3.num_iters_list;
% s3m4 = load('num_iters_list3m4.mat'); s3m4 = s3m4.num_iters_list;
% s4m7 = load('num_iters_list4m7.mat'); s4m7 = s4m7.num_iters_list;
% s4m8 = load('num_iters_list4m8.mat'); s4m8 = s4m8.num_iters_list;
% s5m7 = load('num_iters_list5m7.mat'); s5m7 = s5m7.num_iters_list;
% s5m8 = load('num_iters_list5m8.mat'); s5m8 = s5m8.num_iters_list;
% 
% figure(fig_num);
% fig_num = fig_num + 1;
% 
% plot(lr,s2m3, 'LineWidth', 1.5); hold on; plot(lr,s2m4, 'LineWidth', 1.5); hold on; 
% plot(lr,s3m3, 'LineWidth', 1.5); hold on; plot(lr,s3m4, 'LineWidth', 1.5); hold on; 
% plot(lr,s4m7, 'LineWidth', 1.5); hold on; plot(lr,s4m8, 'LineWidth', 1.5); hold on; 
% plot(lr,s5m7, 'LineWidth', 1.5); hold on; plot(lr,s5m8, 'LineWidth', 1.5);
% legend('2 sources, 3 mics', '2 sources, 4 mics', '3 sources, 3 mics', ...
%        '3 sources, 4 mics', '4 sources, 7 mics', '4 sources, 8 mics', ...
%        '5 sources, 7 mics',  '5 sources, 8 mics');
