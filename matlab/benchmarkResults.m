
clear all
clc

d = 0.2;
%%
planners = {'BiRRT','RRT','SBL'};
plannerType = planners{1};
switch plannerType
    case 'BiRRT'
        D{1} = load('Benchmark_BiRRT_PCS.txt'); 
        D{2} = load('Benchmark_BiRRT_GD.txt');
        D{3} = load('Benchmark_BiRRT_SG.txt');
        D{1} = [0.8*ones(size(D{1},1),1) D{1}];
        D{2} = [1.4*ones(size(D{2},1),1) D{2}];
        D{3} = [0.2*ones(size(D{3},1),1) D{3}];
        D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = D{2}(D{2}(:,2)==1,:); 
        D{3} = D{3}(D{3}(:,2)==1,:); 
    case 'RRT'
        D{1} = load('Benchmark_RRT_PCS.txt'); 
        D{2} = load('Benchmark_RRT_GD.txt');
        D{1} = [1.4*ones(size(D{1},1),1) D{1}];
        D{2} = [1.8*ones(size(D{2},1),1) D{2}];
        D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = D{2}(D{2}(:,2)==1,:); 
    case 'SBL'
        D{1} = load('Benchmark_SBL_PCS.txt'); 
        D{2} = load('Benchmark_SBL_GD.txt');
        D{3} = load('Benchmark_SBL_SG.txt');
        D{1} = [0.6*ones(size(D{1},1),1) D{1}];
        D{2} = [0.6*ones(size(D{2},1),1) D{2}];
        D{3} = [0.6*ones(size(D{2},1),1) D{2}];
        D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = D{2}(D{2}(:,2)==1,:); 

end

%%
disp(['Results for ' plannerType ':']);

%%

for k = 1:size(D,2)
    
    suc = D{k}(:,2)==1;
    F(:,k) = mean(D{k});
    
    tmin(k) = F(4,k);
end

% clc
disp('-----------------------------------');
fprintf('         \t\tPCS\tNR\tRSS\n');
fprintf('Queries: \t\t%d\t%d\t%d\n', size(D{1},1), size(D{2},1), size(D{3},1));
fprintf('d =      \t\t%.1f\t%.1f\t%.1f\n', F(1,1), F(1,2), F(1,3));
fprintf('Avg. time (for d): \t%.2f\t%.2f\t%.2f \t(sec)\n', F(4,1), F(4,2), F(4,3));
fprintf('Min. time (for d): \t%.2f\t%.2f\t%.2f \t(sec)\n', min(D{1}(:,4)), min(D{2}(:,4)), min(D{3}(:,4)));
fprintf('Nodes in path:     \t%.1f\t%.1f\t%.1f\n', F(10,1), F(10,2), F(10,3));
fprintf('Nodes in trees:    \t%.1f\t%.1f\t%.1f\n', F(11,1), F(11,2), F(11,3));
disp('------------ Sampling -------------');
fprintf('Sampling time:    \t%.2f\t%.2f\t%.2f \t(sec)\n', F(15,1), F(15,2), F(15,3));
fprintf('Sampling count: \t%.1f\t%.1f\t%.1f \t(%%)\n', F(16,1)+F(17,1), F(16,2)+F(17,2), F(16,3)+F(17,3));
fprintf('Sampling success: \t%.2f\t%.2f\t%.2f \t(%%)\n', 100*F(16,1)/(F(16,1)+F(17,1)), 100*F(16,2)/(F(16,2)+F(17,2)), 100*F(16,3)/(F(16,3)+F(17,3)));
disp('------------ loc.-con. ------------');
fprintf('Loc.-con. time:    \t%.2f\t%.2f\t%.2f \t(sec)\n', F(12,1), F(12,2), F(12,3));
fprintf('Loc.-con. count:   \t%.2f\t%.2f\t%.2f \t\n', F(13,1), F(13,2), F(13,3));
fprintf('Loc.-con. success: \t%.2f\t%.2f\t%.2f \t(%%)\n', 100*F(14,1)/F(13,1), 100*F(14,2)/F(13,2), 100*F(14,3)/F(13,3));
disp('----------- Projection ------------');
fprintf('Proj. time:        \t%.2f\t%.2f\t%.2f \t(sec)\n', F(6,1), F(6,2), F(6,3));
fprintf('Proj. count:       \t%.2f\t%.2f\t%.2f \t\n', F(5,1), F(5,2), F(5,3));

%%
disp(' ');
fprintf('Speed-up (at d = %.1f):      %.2f\n', d, tmin(2)/tmin(1));

%%
%%
%%
% PCS
td = D{1}(:,4);
maxT = max(td);
T1 = linspace(0,maxT,100);
T1 = T1(2:end);
for i = 1:length(T1)
    sd = td < T1(i);
    md(i) = mean(td(sd));
    Md(i) = 1-sum(sd)/length(td);
end
%%
% GD
tg = D{2}(:,4);
maxT = max(tg);
T2 = linspace(0,maxT,100);
T2 = T2(2:end);
for i = 1:length(T2)
    sg = tg < T2(i);
    mg(i) = mean(tg(sg));
    Mg(i) = 1-sum(sg)/length(tg);
end

%%
% RSS
ts = D{3}(:,4);
maxT = max(ts);
T3 = linspace(0,maxT,100);
T3 = T3(2:end);
for i = 1:length(T3)
    ss = ts < T3(i);
    ms(i) = mean(ts(ss));
    Ms(i) = 1-sum(ss)/length(ts);
end

%%
h = figure(2);
clf
plot(T1,Md*100,'-k','linewidth',2);
hold on
plot(T2,Mg*100,'--k','linewidth',2);
plot(T3,Ms*100,'--k','linewidth',2);
hold off
xlabel('maximum runtime (sec)');
ylabel('failure rate (%)');
legend('PCS','NR','RSS');
% xlim([0 8]);%max([T1 T2])]);
% title(plannerType);
set(gca,'fontsize',13);
% set(h, 'Position', [100, 100, 800, 400]);
% print PCS_NR_runtime.eps -depsc -r200