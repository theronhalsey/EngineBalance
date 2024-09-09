% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;

% time parameters
dt = .000001; % time increment in seconds
t = 0:dt:p-dt;

% crankshaft (assume crankshaft is balanced)
crank_l = 0.099060; % length of crank throw in meters (3.9' stroke)

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
tiledlayout(1,2);

% piston head location
nexttile
hold on
title("Piston Head Displacement")
plot(t,head_xy(1,:),Color='r',LineStyle='-')
plot(t,head_xy(2,:),Color='b',LineStyle='-')
legend("x", "y",Location='southoutside')

% piston head velocity and acceleration
nexttile
hold on
title("Piston Head Velocity and Acceleration")

% plot velocity
yyaxis left
plot(t,head_v(1,:),Color='r',LineStyle='-')
plot(t,head_v(2,:),Color='b',LineStyle='-')
yliml = get(gca,"Ylim"); % y limit for aligning 0 on both y-axes
ratio = yliml(1)/yliml(2);

% plot acceleration
yyaxis right
plot(t,head_a(1,:),Color='g',LineStyle='-')
plot(t,head_a(2,:),Color='m',LineStyle='-')
ylimr = get(gca,'Ylim');

% format combined plot
yline(0,Color='k') % draw a line at 0
if ylimr(2)*ratio<ylimr(1) % align 0 on left and right axes
    set(gca,'Ylim',[ylimr(2)*ratio ylimr(2)])
else
    set(gca,'Ylim',[ylimr(1) ylimr(1)/ratio])
end
legend("Velocity x","Velocity y","Acceleration x","Acceleration y",'',Location='southoutside')