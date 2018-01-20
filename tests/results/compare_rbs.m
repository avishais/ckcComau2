clear all
clc

% Dgd = load('gd_rbs_verification_withObs.txt');
% Dpcs = [load('pcs_rbs_verification_withObs.txt'); 
%     load('pcs_rbs_verification_withObs2.txt')]; 
% Drss = [load('rss_rbs_verification_withObs.txt');
%     load('rss_rbs_verification_withObs1.txt')];

Dgd = load('gd_rbs_verification_woObs.txt');
Dpcs = load('pcs_rbs_verification_woObs.txt'); 
Drss = [load('rss_rbs_verification_withObs.txt');
    load('rss_rbs_verification_withObs1.txt')];


clear Vgd Vpcs Vrss Vrlx
clear dgd dpcs drss drlx
%% gd

bins = 30;

D = Dgd;
clear V d
Dd = D(:,3);
max_d = max(Dd);
d = linspace(0, max_d, bins);
% V = zeros(bins,1);
for i = 2:length(d)
    S = D(D(:,3)>=d(i-1) & D(:,3)<d(i), 1);
    V(i-1) = (sum(S)/length(S)) * 100;
end
Vgd = V;
dgd = d(2:end);

%% pcs

bins = 30;

D = Dpcs;
clear V d
Dd = D(:,3);
max_d = max(Dd);
d = linspace(0, max_d, bins);
% V = zeros(bins,1);
for i = 2:length(d)
    S = D(D(:,3)>=d(i-1) & D(:,3)<d(i), 1);
    V(i-1) = (sum(S)/length(S)) * 100;
end
Vpcs = V;
dpcs = d(2:end);

%% rss

bins = 30;

D = Drss;
Dd = D(:,3);
clear V d
max_d = max(Dd);
d = linspace(0, max_d, bins);
% V = zeros(bins,1);
for i = 2:length(d)
    S = D(D(:,3)>=d(i-1) & D(:,3)<d(i), 1);
    V(i-1) = (sum(S)/length(S)) * 100;
end
Vrss = V;
drss = d(2:end);

%% plot

h = figure(1);
clf
plot(dpcs, Vpcs,'-k','linewidth',2)
hold on
plot(dgd, Vgd,'--k','linewidth',2)
plot(drss, Vrss,':k','linewidth',2)
hold off
legend('PCS','NR','RSS','location','northeast');
set(gca,'fontsize',14);
xlim([max([dpcs(1) dgd(1)]) max([dpcs(end) dgd(end) ])]); %drss(end)
xlabel('distance: $\sqrt{(\phi_1-\phi_2)^T(\phi_1-\phi_2)}$','Interpreter','latex');
ylabel('success rate (%)');
set(h, 'Position', [100, 100, 800, 280]);
% print successRate.eps -depsc -r200

%%

disp(['PCS visibility: ' num2str(sum(Dpcs(:,1))/size(Dpcs,1)*100) ]);
disp(['NR visibility: ' num2str(sum(Dgd(:,1))/size(Dgd,1)*100) ]);
disp(['RSS visibility: ' num2str(sum(Drss(:,1))/size(Drss,1)*100) ]);