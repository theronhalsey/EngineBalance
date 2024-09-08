rpm = 4000;
rps = rpm/60;
p = 1/rps;
half_p = p/2;
dt = .000001; % time increment in seconds
head_m = 1.0; % mass of piston head in kg
rod_m = 5.44311; %mass of piston rod in kg (12 lbs)
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters
rod_com = [rod_l/2; rod_w/2]; % [x; y] of center of mass of connecting rod
crank_l = 0.099060; % length of crank throw in meters (3.9' stroke)
% assume crankshaft is balanced
tdc_l = rod_l + crank_l;
bdc_l = rod_l - crank_l;

%% Function Handles
crank_angle = @(t) 2*pi*rps.*mod(t,p);
rod_angle = @(t) asin((crank_l/rod_l) * sin(crank_angle(t))); % calculate the angle between the crank arm and piston rod
crank_rod_angle = @(t) pi - rod_angle(t) - crank_angle(t); % calculate the angle between the piston stroke and piston rod
crank_x = @(t) crank_l .* cos(crank_angle(t)); % calculate the x position of the crank arm end at time t

t = 0:dt:2*p;
head_y = arrayfun(@(t) calc_head_y(t,crank_rod_angle,crank_angle,p,half_p,tdc_l,bdc_l,rod_l), t);
head_v = diff(head_y)/dt;
head_a = diff(head_v)/dt;
f = head_m*head_a;

%% Plotting
tiledlayout(1,2);

nexttile
hold on
title("Piston Head Location")
yline(rod_l+crank_l)
yline(rod_l-crank_l)
plot(t,head_y)

nexttile
hold on
title("Piston Head Velocity and Acceleration")
yyaxis left
plot(t(2:end),head_v,Color='b')
yliml = get(gca,"Ylim");
ratio = yliml(1)/yliml(2);
yyaxis right
plot(t(3:end),head_a,Color='r')
ylimr = get(gca,'Ylim');
yline(0,Color='k')
if ylimr(2)*ratio<ylimr(1)
    set(gca,'Ylim',[ylimr(2)*ratio ylimr(2)])
else
    set(gca,'Ylim',[ylimr(1) ylimr(1)/ratio])
end
legend("Velocity", "Acceleration",'',Location='southoutside')
legend('boxoff')

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