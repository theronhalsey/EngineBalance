% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;
half_p = p/2;

% time parameters
dt = .000001; % time increment in seconds
t = 0:dt:2*p;