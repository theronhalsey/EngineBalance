head_m = 1.0; % mass of piston head in kg
rod_l = .155575; % length of connecting rod in meters
crank_l = .099060; % length of crank throw in meters

crank_angle = @(t) mod(t,2*pi);
crank_rod_angle = asin(sin(crank_angle(t)*crank_l/rod_l)); % calculate the angle between the crank arm and piston rod
stroke_rod_angle = @(t) pi - crank_rod_angle(t) - crank_angle(t); % calculate the angle between the piston stroke and piston rod
crank_x = @(t) crank_l * cos(crank_angle(t)); % calculate the x position of the crank arm end at time t


t = 0:.001:2*pi;
plot(t,crank_x(t))