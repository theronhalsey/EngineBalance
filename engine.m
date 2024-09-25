function [engineForces,crankshaftForces] = engine(n_pistons,piston_layout,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale)


%% Common Parameters
% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;

% time parameters
dt = .00005; % time increment in seconds
t = 0:dt:p+dt;
n_points = length(t)-2;

% crankshaft (assume crankshaft is balanced)
bore_d = 0.11176; % distance between each piston connection in meters (4.4")
switch piston_layout
    case 'i'
        shaft_l = bore_d * n_pistons;
    case 'r'
        shaft_l = bore_d;
    otherwise
        shaft_l = .5 * bore_d * (n_pistons + 1);
end

stroke_l = 0.099060/2; % length of crank throw in meters (3.9' stroke)
f_crank_angle = @(t) 2*pi*rps.*mod(t,p);
crank_angles = f_crank_angle(t);
crank_xy = stroke_l/4 .* [cos(crank_angles); sin(crank_angles)]; % track the motion of a single point of the crank shaft for refrence

% piston parameters
head_m = .610; % mass of piston head in kg

% piston rod
rod_m = .65317; % mass of piston rod in kg
rod_l = 0.1525; % length of connecting rod in meters (6' rod)

% counterweight
counterweight_m = (head_m+rod_m) * ones(1,n_pistons) * counterweight_scale; % mass of counterweight
counterweight_l = stroke_l * .5 * ones(1,n_pistons); % distance to center of mass of counterweight from center of crankshaft

%% Calculate Piston Forces
engineForces = zeros(14,n_points,n_pistons);
for i=1:n_pistons
    engineForces(:,:,i) = piston(dt,crank_angles,crank_offsets(i),stroke_l,head_m,piston_angles(i),rod_m,rod_l,counterweight_m(i),counterweight_l(i),counterweight_offsets(i));
end

% total force on crankshaft at time t
crankshaftForces = [crank_xy(:,1:end-2); -(sum(engineForces(9:10,:,:),3) + sum(engineForces(11:12,:,:),3) + sum(engineForces(13:14,:,:),3))];