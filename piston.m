rpm = 4000;
rps = rpm/60;
p = 1/rps;
half_p = p/2;
dt = .000001; % time increment in seconds
head_m = 1.0; % mass of piston head in kg
rod_l = .155575; % length of connecting rod in meters
crank_l = .099060; % length of crank throw in meters
tdc_l = rod_l + crank_l;
bdc_l = rod_l - crank_l;

crank_angle = @(t) 2*pi*rps.*mod(t,p);
rod_angle = @(t) asin((crank_l/rod_l) * sin(crank_angle(t))); % calculate the angle between the crank arm and piston rod
crank_rod_angle = @(t) pi - rod_angle(t) - crank_angle(t); % calculate the angle between the piston stroke and piston rod
crank_x = @(t) crank_l .* cos(crank_angle(t)); % calculate the x position of the crank arm end at time t

t = 0:dt:2*p;
y = arrayfun(@(t) head_y(t,crank_rod_angle,crank_angle,p,half_p,tdc_l,bdc_l,rod_l), t);
a = diff(y)/dt;
f = head_m*a;

hold on
yyaxis left
yline(rod_l+crank_l)
yline(rod_l-crank_l)
plot(t,y)

yyaxis right
plot(t(2:end),f)

function y = head_y(t,crank_rod_angle,crank_angle,p,half_p,tdc_l,bdc_l,rod_l) % calculate the y position of the piston head
switch mod(t,p)
    case 0
        y = tdc_l;
    case half_p
        y = bdc_l;
    otherwise
        y = rod_l * sin(crank_rod_angle(t)) ./ sin(crank_angle(t));
end
end