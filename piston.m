% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;
half_p = p/2;

% time parameters
dt = .000001; % time increment in seconds
t = 0:dt:2*p;

% piston angle parameters
piston_angle = 0;
crank_offset = 0;

% piston head
head_m = 1.0; % mass of piston head in kg

% piston rod
rod_m = 5.44311; %mass of piston rod in kg (12 lbs)
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters
rod_com = [rod_l/2; rod_w/2]; % [x; y] of center of mass of connecting rod

% crankshaft (assume crankshaft is balanced)
crank_l = 0.099060; % length of crank throw in meters (3.9' stroke)

% top and bottom dead center
tdc_l = rod_l + crank_l;
bdc_l = rod_l - crank_l;

%% Calculate Angles and Displacement
f_crank_angle = @(t) 2*pi*rps.*mod(t,p) + crank_offset;
crank_angles = f_crank_angle(t);
rod_angles = asin((crank_l/rod_l) * sin(crank_angles)); % calculate the angle between the crank arm and piston rod
crank_rod_angles = pi - rod_angles - crank_angles; % calculate the angle between the piston stroke and piston rod
head_displacement = sqrt(crank_l^2 + rod_l^2 - 2*crank_l*rod_l * cos(crank_rod_angles)); % piston head displacement along stroke

%f_crank_xy = @(t) crank_l .* [cos(f_crank_angle(t)); sin(f_crank_angle(t))]; % calculate the [x;y] positions of the crank arm end at time t

%% Calculate Forces
% piston head
head_xy = head_displacement .* [sin(piston_angle); cos(piston_angle)]; % piston head location
head_v = [diff(head_xy(1,:)); diff(head_xy(2,:))]/dt; % piston head velocity
head_a = [diff(head_v(1,:)); diff(head_v(2,:))]/dt; % piston head acceleration
head_f = head_m*head_a; % piston head force

% piston rod
rod_xy = crank_l .* [0.5 * sin(crank_angles); 0.5 * rod_l + cos(crank_angles)];
rod_v = [diff(rod_xy(1,:)); diff(rod_xy(2,:))]/dt;
rod_a = [diff(rod_v(1,:)); diff(rod_v(2,:))]/dt;
rod_f = rod_m*rod_a;

%% Plotting
tiledlayout(2,2);

% piston head location
nexttile
hold on
title("Piston Head Displacement")
plot(t(3:end),head_xy(1,3:end),Color='r',LineStyle='-')
plot(t(3:end),head_xy(2,3:end),Color='b',LineStyle='-')
legend("x", "y",Location='southoutside')

% piston head velocity and acceleration
nexttile
hold on
title("Piston Head Velocity and Acceleration")

% plot velocity
yyaxis left
plot(t(3:end),head_v(1,2:end),Color='r',LineStyle='-')
plot(t(3:end),head_v(2,2:end),Color='b',LineStyle='-')
yliml = get(gca,"Ylim"); % y limit for aligning 0 on both y-axes
ratio = yliml(1)/yliml(2);

% plot acceleration
yyaxis right
plot(t(3:end),head_a(1,:),Color='g',LineStyle='-')
plot(t(3:end),head_a(2,:),Color='m',LineStyle='-')
ylimr = get(gca,'Ylim');

% format combined plot
yline(0,Color='k') % draw a line at 0
if ylimr(2)*ratio<ylimr(1) % align 0 on left and right axes
    set(gca,'Ylim',[ylimr(2)*ratio ylimr(2)])
else
    set(gca,'Ylim',[ylimr(1) ylimr(1)/ratio])
end
legend("Velocity x","Velocity y","Acceleration x","Acceleration y",'',Location='southoutside')

nexttile
plot(rod_xy(1,1:(end-1)), rod_xy(2,1:(end-1)))