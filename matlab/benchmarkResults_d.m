

% last updated: 

clear all
clc

d = 2.8;
%%
planners = {'BiRRT','RRT','SBL'};
plannerType = planners{2};
switch plannerType
    case 'BiRRT'
        D{1} = load('Benchmark_BiRRT_PCS_rB.txt'); D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = load('Benchmark_BiRRT_GD_rB.txt'); D{2} = D{2}(D{2}(:,2)==1,:); 
        D{3} = load('Benchmark_BiRRT_SG_rB.txt'); D{3} = D{3}(D{3}(:,2)==1,:); 
    case 'RRT'
        D{1} = load('Benchmark_RRT_PCS_rB.txt'); D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = load('Benchmark_RRT_GD_rB.txt'); D{2} = D{2}(D{2}(:,2)==1,:); 
        D{3} = load('Benchmark_RRT_GD_rB.txt'); D{3} = D{3}(D{3}(:,2)==1,:);
    case 'SBL'
        D{1} = load('Benchmark_SBL_PCS_rB.txt'); D{1} = D{1}(D{1}(:,2)==1,:); 
        D{2} = load('Benchmark_SBL_GD_rB.txt'); D{2} = D{2}(D{2}(:,2)==1,:); 
        D{3} = load('Benchmark_SBL_SG_rB.txt'); D{3} = D{3}(D{3}(:,2)==1,:);
end

%%
disp(['Results for ' plannerType ':']);

%%

for k = 1:size(D,2)
    
    r{k} = sort(unique(D{k}(:,1)));
    for i = 1:length(r{k})
        M = D{k}(D{k}(:,1)==r{k}(i), 1:end);
        t{k}(i) = mean(M(:,4));
        t_ste{k}(i) = 1e3*std(M(:,4))/sqrt(size(M,1));
    end
    
    [tmin(k), im(k)] = min(t{k});
end

%%
h = figure(1);
clf
% errorbar(r{1},t{1},t_ste{1},'-k','linewidth',2);
plot(r{1},t{1},'-k','linewidth',2);
hold on
% errorbar(r{2},t{2},t_ste{2},'--k','linewidth',2);
plot(r{2},t{2},'--k','linewidth',2);
plot(r{3},t{3},':k','linewidth',2);
hold off
ylabel('mean runtime [msec]');
xlabel('max. local-connection distance');
legend('PCS','NR','RSS');
% xlim([0 6]);
% xlim([min(rd) max(rd)]);

%%

for k = 1:size(D,2)
    
    sS = r{k}(im(k));
    
    D{k} = D{k}(D{k}(:,1)==sS, 1:end);
    suc = D{k}(:,2)==1;
    F(:,k) = mean(D{k},1);
    
    tmin(k) = F(4,k);
end

clc
disp('-----------------------------------');
fprintf('         \t\tPCS\tNR\tRSS\n');
fprintf('Queries: \t\t%d\t%d\t%d\n', size(D{1},1), size(D{2},1), size(D{3},1));
fprintf('d =      \t\t%.1f\t%.1f\t%.1f\n', F(1,1), F(1,2), F(1,3));
fprintf('Avg. time (for d): \t%.2f\t%.2f\t%.2f \t(sec)\n', F(4,1), F(4,2), F(4,3));
fprintf('Min. time (for d): \t%.2f\t%.2f\t%.2f \t(sec)\n', min(D{1}(:,4)), min(D{2}(:,4)), min(D{3}(:,4)));
fprintf('Nodes in path:     \t%.1f\t%.1f\n', F(10,1), F(10,2));
fprintf('Nodes in trees:    \t%.1f\t%.1f\n', F(11,1), F(11,2));
disp('------------ Sampling -------------');
fprintf('Sampling time:    \t%.2f\t%.2f \t(sec)\n', F(15,1), F(15,2));
fprintf('Sampling success: \t%.2f\t%.2f \t(%%)\n', 100*F(16,1)/(F(16,1)+F(17,1)), 100*F(16,2)/(F(16,2)+F(17,2)));
disp('------------ loc.-con. ------------');
fprintf('Loc.-con. time:    \t%.2f\t%.2f \t(sec)\n', F(12,1), F(12,2));
fprintf('Loc.-con. count:   \t%.2f\t%.2f \t\n', F(13,1), F(13,2));
fprintf('Loc.-con. success: \t%.2f\t%.2f \t(%%)\n', 100*F(14,1)/F(13,1), 100*F(14,2)/F(13,2));
disp('----------- Projection ------------');
fprintf('Proj. time:        \t%.2f\t%.2f \t(sec)\n', F(6,1), F(6,2));
fprintf('Proj. count:       \t%.2f\t%.2f \t\n', F(5,1), F(5,2));

%%
disp(' ');
fprintf('Speed-up:      %.2f\n', d, tmin(2)/tmin(1));



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
maxT = max(tg);
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
plot(T3,Ms*100,':k','linewidth',2);
hold off
xlabel('maximum runtime (sec)');
ylabel('failure rate (%)');
legend('PCS','NR','RSS');
% xlim([0 1.2]);%max([T1 T2])]);
% title(plannerType);
set(gca,'fontsize',13);
% set(h, 'Position', [100, 100, 800, 400]);
% print PCS_NR_runtime.eps -depsc -r200