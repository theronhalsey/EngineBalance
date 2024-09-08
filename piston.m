% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;
half_p = p/2;

% time parameters
dt = .000001; % time increment in seconds
t = 0:dt:(3/4)*p;

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

%% Function Handles
crank_angle = @(t) 2*pi*rps.*mod(t,p);
rod_angle = @(t) asin((crank_l/rod_l) * sin(crank_angle(t))); % calculate the angle between the crank arm and piston rod
crank_rod_angle = @(t) pi - rod_angle(t) - crank_angle(t); % calculate the angle between the piston stroke and piston rod
crank_xy = @(t) crank_l .* [cos(crank_angle(t)); sin(crank_angle(t))]; % calculate the [x;y] positions of the crank arm end at time t
rod_com_xy = @(t) crank_l .* [0.5 * sin(crank_angle(t)); 0.5 * rod_l + cos(crank_angle(t))]; % calculate the [x;y] positions of com of connecting rod at time t

%% Calculation
% piston head
head_y = arrayfun(@(t) calc_head_y(t,crank_rod_angle,crank_angle,p,half_p,tdc_l,bdc_l,rod_l), t); % piston head location
head_v = diff(head_y)/dt; % piston head velocity
head_a = diff(head_v)/dt; % piston head acceleration
head_f = head_m*head_a; % piston head force

% piston rod
rod_xy = rod_com_xy(t);
rod_v = [diff(rod_xy(1,:)); diff(rod_xy(2,:))]/dt;
rod_a = [diff(rod_v(1,:)); diff(rod_v(2,:))]/dt;
rod_f = rod_m*rod_a;

%% Plotting
tiledlayout(1,3);

% piston head location
nexttile
hold on
title("Piston Head Location")
yline(rod_l+crank_l) % max displacement
yline(rod_l-crank_l) % min displacement
plot(t(3:end),head_y(3:end))

% piston head velocity and acceleration
nexttile
hold on
title("Piston Head Velocity and Acceleration")

% plot velocity
yyaxis left
plot(t(3:end),head_v(2:end),Color='b')
yliml = get(gca,"Ylim"); % y limit for aligning 0 on both y-axes
ratio = yliml(1)/yliml(2);

% plot acceleration
yyaxis right
plot(t(3:end),head_a,Color='r')
ylimr = get(gca,'Ylim');

% format combined plot
yline(0,Color='k') % draw a line at 0
if ylimr(2)*ratio<ylimr(1) % align 0 on left and right axes
    set(gca,'Ylim',[ylimr(2)*ratio ylimr(2)])
else
    set(gca,'Ylim',[ylimr(1) ylimr(1)/ratio])
end
legend("Velocity", "Acceleration",'',Location='southoutside')
legend('boxoff')

nexttile
plot(rod_xy(1,1:(end-1)), rod_xy(2,1:(end-1)))

%% Functions
function y = calc_head_y(t,crank_rod_angle,crank_angle,p,half_p,tdc_l,bdc_l,rod_l) % calculate the y position of the piston head
switch mod(t,p)
    case 0
        y = tdc_l;
    case half_p
        y = bdc_l;
    otherwise
        y = rod_l * sin(crank_rod_angle(t)) ./ sin(crank_angle(t));
end
end