% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;

% time parameters
dt = .000001; % time increment in seconds
t = 0:dt:p-dt;

% crankshaft (assume crankshaft is balanced)
crank_l = 0.099060; % length of crank throw in meters (3.9' stroke)
f_crank_angle = @(t) 2*pi*rps.*mod(t,p) + crank_offset;
crank_angles = f_crank_angle(t);

% piston parameters
head_m = 1.0; % mass of piston head in kg
piston_angle = 0;
crank_offset = 0;

% counterweight
counterweight_m = 0.5; % mass of counterweight
counterweight_l = 0.099060; % distance to center of mass of counterweight from center of crankshaft
counterweight_offset = 0;

% piston rod
rod_m = 5.44311; %mass of piston rod in kg (12 lbs)
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters

Forces = piston(p,rps,t,dt,crank_l,head_m,piston_angle,crank_offset,rod_m,rod_l,counterweight_m,counterweight_l,counterweight_offset);

crank_xy = Forces(1:2,:);
head_xy = Forces(3:4,:);
head_f = Forces(5:6,:);
rod_xy = Forces(7:8,:);
rod_f = Forces(9:10,:);
counterweight_xy = Forces(11:12,:);
counterweight_f = Forces(13:14,:);

%% Plotting
tiledlayout(1,3);

% piston head
nexttile
hold on
title("Piston Head")
yyaxis left
plot(t,head_xy(1,:),Color='r',LineStyle='-')
plot(t,head_xy(2,:),Color='g',LineStyle='-')
yyaxis right
plot(t,head_f(1,:),Color='b',LineStyle='-')
plot(t,head_f(2,:),Color='m',LineStyle='-')
legend("x-displacement","y-displacement","x-force","y-force",Location='southoutside')

% piston rod
nexttile
hold on
title("Piston Rod")
yyaxis left
plot(t,rod_xy(1,:),Color='r',LineStyle='-')
plot(t,rod_xy(2,:),Color='g',LineStyle='-')
yyaxis right
plot(t,rod_f(1,:),Color='b',LineStyle='-')
plot(t,rod_f(2,:),Color='m',LineStyle='-')
legend("x-displacement", "x-force","y-displacement", "y-force",Location='southoutside')

% plot counterweight
nexttile
hold on
title("Counterweight")
yyaxis left
plot(t,counterweight_xy(1,:),Color='r',LineStyle='-')
plot(t,counterweight_xy(2,:),Color='g',LineStyle='-')
yyaxis right
plot(t,counterweight_f(1,:),Color='b',LineStyle='-')
plot(t,counterweight_f(2,:),Color='m',LineStyle='-')
legend("x-displacement", "x-force","y-displacement", "y-force",Location='southoutside')

% plot total force on crankshaft