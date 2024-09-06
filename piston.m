rpm = 4000;
rps = rpm/60;
p = 1/rps;
head_m = 1.0; % mass of piston head in kg
rod_l = .155575; % length of connecting rod in meters
crank_l = .099060; % length of crank throw in meters

ar = @(t) 2*pi*rps.*mod(t,p);
ac = @(t) asin( (crank_l/rod_l) * sin(ar(t)) ); % calculate the angle between the crank arm and piston rod
ah = @(t) pi - abs(ac(t)) - abs(ar(t)); % calculate the angle between the piston stroke and piston rod

crank_x = @(t) crank_l .* cos(ar(t)); % calculate the x position of the crank arm end at time t
head_y = @(t) rod_l * sin(ah(t)) ./ sin(ar(t)); % calculate the y position of the piston head

t = 0:.00001:p;
hold on
yline(rod_l+crank_l)
yline(rod_l-crank_l)
plot(t(2:end-1),head_y(t(2:end-1)))