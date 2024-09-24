function [engineForces,crankshaftForces] = engine(n_pistons,piston_layout,piston_angles,crank_offsets)
% toggles for which forces to show in animation
showHeadForces = 1;
showRodForces = 1;
showCounterweightForces = 1;

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
head_d = 0.101727; % diameter of piston bore (4.005")

% piston rod
rod_m = .65317; % mass of piston rod in kg
rod_l = 0.1525; % length of connecting rod in meters (6' rod)

% counterweight
counterweight_m = (head_m+rod_m) * ones(1,n_pistons); % mass of counterweight
counterweight_l = stroke_l * .5 * ones(1,n_pistons); % distance to center of mass of counterweight from center of crankshaft
counterweight_offset = crank_offsets + pi;

%% Calculate Piston Forces
engineForces = zeros(14,n_points,n_pistons);
for i=1:n_pistons
    engineForces(:,:,i) = piston(dt,crank_angles,crank_offsets(i),stroke_l,head_m,piston_angles(i),rod_m,rod_l,counterweight_m(i),counterweight_l(i),counterweight_offset(i));
end

% total force on crankshaft at time t
crankshaftForces = [crank_xy(:,1:end-2); -(sum(engineForces(9:10,:,:),3) + sum(engineForces(11:12,:,:),3) + sum(engineForces(13:14,:,:),3))];

% max displacement and force
max_displacement = max(abs(engineForces(3:4,:,:)),[],'all');
max_component_force = max(abs(engineForces(9:end,:,:)),[],'all');
max_force_cranfshaft = max(abs(crankshaftForces(3:end,:)),[],'all');
max_force = max([max_component_force max_force_cranfshaft]);

% scale displacement to force
scale = max_force/max_displacement;
crank_xy = crank_xy * scale;
engineForces(1:8,:,:) = engineForces(1:8,:,:) * scale;

%% Animation
piston_head_color = 'r';
rod_color = 'b';
counterweight_color = 'g';
crank_arm_color = 'm';
crank_shaft_color = 'k';
axis_max = ceil(1.1*max_force);
set(gca,'XLim',[-axis_max axis_max],'YLim',[-axis_max axis_max],'XTick',[-axis_max 0 axis_max],'YTick',[-axis_max 0 axis_max]);

% lines for piston heads
piston_head_location = animatedline().empty(0,n_pistons);
piston_head_path = animatedline().empty(0,n_pistons);
if showHeadForces
    piston_head_force_x = animatedline().empty(0,n_pistons);
    piston_head_force_y = animatedline().empty(0,n_pistons);
end

% lines for piston rods
rod_com_location = animatedline().empty(0,n_pistons);
rod_com_path = animatedline().empty(0,n_pistons);
rod_body = animatedline().empty(0,n_pistons);
if showRodForces
    rod_com_force_x = animatedline().empty(0,n_pistons);
    rod_com_force_y = animatedline().empty(0,n_pistons);
end

% lines for piston counterweights
counterweight_location = animatedline().empty(0,n_pistons);
counterweight_path = animatedline().empty(0,n_pistons);
if showCounterweightForces
    counterweight_force_x = animatedline().empty(0,n_pistons);
    counterweight_force_y = animatedline().empty(0,n_pistons);
end

% lines for crank shafts
crank_arm_location = animatedline().empty(0,n_pistons);
crank_arm_path = animatedline().empty(0,n_pistons);

% define styles for each line for each piston component
for i=1:n_pistons
    piston_head_location(i) = animatedline('color',piston_head_color,'Marker','.','markersize',20);
    piston_head_path(i) = animatedline('color',piston_head_color,'LineStyle','-');
    if showHeadForces
        piston_head_force_x(i) = animatedline('color',piston_head_color,'LineStyle','-');
        piston_head_force_y(i) = animatedline('color',piston_head_color,'LineStyle','-');
    end

    rod_com_location(i) = animatedline('color',rod_color,'Marker','.','markersize',20);
    rod_com_path(i) = animatedline('color',rod_color,'LineStyle','-');
    rod_body(i) = animatedline('color',rod_color,'LineStyle','-');
    if showRodForces
        rod_com_force_x(i) = animatedline('color',rod_color,'LineStyle','-');
        rod_com_force_y(i) = animatedline('color',rod_color,'LineStyle','-');
    end

    counterweight_location(i) = animatedline('color',counterweight_color,'LineStyle','-','Marker','.','markersize',20);
    counterweight_path(i) = animatedline('color',counterweight_color,'LineStyle','-');
    if showCounterweightForces
        counterweight_force_x(i) = animatedline('color',counterweight_color,'LineStyle','-');
        counterweight_force_y(i) = animatedline('color',counterweight_color,'LineStyle','-');
    end

    crank_arm_location(i) = animatedline('color',crank_arm_color,'LineStyle','-','Marker','.','markersize',20);
    crank_arm_path(i) = animatedline('color',crank_arm_color,'LineStyle','-');
end

% define styles for crankshaft lines
crank_shaft_point = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_rotation = animatedline('color',crank_shaft_color,'LineStyle','-');
crank_shaft_center = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_force_x = animatedline('color',crank_shaft_color,'LineStyle','-');
crank_shaft_force_y = animatedline('color',crank_shaft_color,'LineStyle','-');
addpoints(crank_shaft_center,0,0)

i = 1; % increment for animation
while 1
    for j=1:n_pistons
        piston_crank_xy = engineForces(1:2,i,j);
        head_xy = engineForces(3:4,i,j);
        rod_xy = engineForces(5:6,i,j);
        counterweight_xy = engineForces(7:8,i,j);
        head_f = engineForces(9:10,i,j);
        rod_f = engineForces(11:12,i,j);
        counterweight_f = engineForces(13:14,i,j);

        clearpoints(piston_head_location(j))
        if showHeadForces
            clearpoints(piston_head_force_x(j))
            clearpoints(piston_head_force_y(j))
        end

        clearpoints(rod_com_location(j))
        clearpoints(rod_body(j))
        if showRodForces
            clearpoints(rod_com_force_x(j))
            clearpoints(rod_com_force_y(j))
        end

        clearpoints(counterweight_location(j))
        if showCounterweightForces
            clearpoints(counterweight_force_x(j))
            clearpoints(counterweight_force_y(j))
        end

        clearpoints(crank_arm_location(j))

        addpoints(piston_head_location(j),head_xy(1),head_xy(2))
        addpoints(piston_head_path(j),head_xy(1),head_xy(2))
        if showHeadForces
            addpoints(piston_head_force_x(j),[head_xy(1) head_xy(1)+head_f(1)], [head_xy(2) head_xy(2)])
            addpoints(piston_head_force_y(j),[head_xy(1) head_xy(1)], [head_xy(2) head_xy(2)+head_f(2)])
        end
        addpoints(rod_body(j),[head_xy(1) piston_crank_xy(1)],[head_xy(2) piston_crank_xy(2)])
        addpoints(crank_arm_location(j),[piston_crank_xy(1) 0],[piston_crank_xy(2) 0])
        addpoints(crank_arm_path(j),piston_crank_xy(1),piston_crank_xy(2))
        addpoints(rod_com_location(j),rod_xy(1),rod_xy(2))
        addpoints(rod_com_path(j),rod_xy(1),rod_xy(2))
        if showRodForces
            addpoints(rod_com_force_x(j),[rod_xy(1) rod_xy(1)+rod_f(1)],[rod_xy(2) rod_xy(2)])
            addpoints(rod_com_force_y(j),[rod_xy(1) rod_xy(1)],[rod_xy(2) rod_xy(2)+rod_f(2)])
        end
        addpoints(counterweight_location(j),[counterweight_xy(1) 0],[counterweight_xy(2) 0])
        addpoints(counterweight_path(j),counterweight_xy(1),counterweight_xy(2))
        if showCounterweightForces
            addpoints(counterweight_force_x(j),[counterweight_xy(1) counterweight_xy(1)+counterweight_f(1)],[counterweight_xy(2) counterweight_xy(2)])
            addpoints(counterweight_force_y(j),[counterweight_xy(1) counterweight_xy(1)],[counterweight_xy(2) counterweight_xy(2)+counterweight_f(2)])
        end
    end
    clearpoints(crank_shaft_point)
    clearpoints(crank_shaft_force_x)
    clearpoints(crank_shaft_force_y)

    addpoints(crank_shaft_force_x,[0 crankshaftForces(3,i)],[0 0])
    addpoints(crank_shaft_force_y,[0 0],[0 crankshaftForces(4,i)])
    addpoints(crank_shaft_rotation,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_shaft_point,[0 crank_xy(1,i)],[0 crank_xy(2,i)])
    drawnow

    i = mod(i,n_points);
    i = i+1;
end