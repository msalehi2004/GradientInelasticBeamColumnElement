clc; clear all;

L = 96;     % GI element length (inches)
N = 10;     % number of integration points

%% Plot Force vs. Displacement
load('Results/Nodes/topDisp.out');      % column's top end displacements
load('Results/Element/globForces.out'); % GI element's global nodal forces

figure(1);
hold on; grid on; box on;
plot(topDisp(11:end,1),globForces(11:end,4),'LineWidth',1.5)

xlabel('Lateral Displacement (in)')
ylabel('Lateral Load (kips)')

%% Plot Curvature Distribution at Peak Displacement
[m,n] = max(topDisp(:,1));

load('Results/Element/lStrains.out');   % material strains
load('Results/Element/nlStrains.out');  % mactroscopic strains

figure(2);
hold on; grid on; box on;
plot(12*lStrains(n,2:2:end),[0:96/(N-1):96]/12,'-*','LineWidth',1.5)
plot(12*nlStrains(n,2:2:end),[0:96/(N-1):96]/12,'-x','LineWidth',1.5)

xlabel('Curvature (rad/ft)')
ylabel('Height (ft)')
legend('Material','Macroscopic')

%% Plot Moment vs. Curvature Response at First Section from Bottom
load('Results/Sections/secDefrm1.out');  % material section strains
load('Results/Sections/secForce1.out');  % section forces

figure(3);
hold on; grid on; box on;
title('First Section')
plot(12*secDefrm1(11:end,2),secForce1(11:end,2)/12,'LineWidth',1.5)
plot(12*nlStrains(11:end,2),secForce1(11:end,2)/12,'LineWidth',1.5)

xlabel('Curvature (rad/ft)')
ylabel('Moment (kip-ft)')
legend('Material','Macroscopic')

%% Plot Moment vs. Curvature Response at Second Section from Bottom
load('Results/Sections/secDefrm2.out');  % material section strains
load('Results/Sections/secForce2.out');  % section forces

figure(4);
hold on; grid on; box on;
title('Second Section')
plot(12*secDefrm2(11:end,2),secForce2(11:end,2)/12,'LineWidth',1.5)
plot(12*nlStrains(11:end,4),secForce2(11:end,2)/12,'LineWidth',1.5)

xlabel('Curvature (rad/ft)')
ylabel('Moment (kip-ft)')
legend('Material','Macroscopic')