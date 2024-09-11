%% Common Parameters
% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;
n_pistons = 4;

% time parameters
dt = .00001; % time increment in seconds
t = 0:dt:p+dt;
n_points = length(t)-2;

% crankshaft (assume crankshaft is balanced)
crank_l = 0.099060/2; % length of crank throw in meters (3.9' stroke)
f_crank_angle = @(t) 2*pi*rps.*mod(t,p);
crank_angles = f_crank_angle(t);
crank_xy = crank_l/4 .* [cos(crank_angles); sin(crank_angles)]; % track the motion of a single point of the crank shaft for refrence

% piston parameters
head_m = 1.0; % mass of piston head in kg

% piston rod
rod_m = 5.44311; %mass of piston rod in kg (12 lbs)
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters

%% Individual Parameters
% piston parameters
piston_angle = 0:pi/4:2*pi;
crank_offset = piston_angle + pi/2;

% counterweight
counterweight_m = 0.5 * ones(1,n_pistons); % mass of counterweight
counterweight_l = crank_l * 0.75 * ones(1,n_pistons); % distance to center of mass of counterweight from center of crankshaft
counterweight_offset = crank_offset + pi;

%% Calculate Piston Forces
Forces = zeros(14,n_points,n_pistons);

parfor i=1:n_pistons
    Forces(:,:,i) = piston(dt,crank_angles,crank_offset(i),crank_l,head_m,piston_angle(i),rod_m,rod_l,counterweight_m(i),counterweight_l(i),counterweight_offset(i));
end

piston_crank_xy = Forces(1:2,:,2);
head_xy = Forces(3:4,:,2);
head_f = Forces(5:6,:,2);
rod_xy = Forces(7:8,:,2);
rod_f = Forces(9:10,:,2);
counterweight_xy = Forces(11:12,:,2);
counterweight_f = Forces(13:14,:,2);
total_f = head_f + rod_f + counterweight_f;

%% Animation
piston_head_color = 'r';
rod_color = 'b';
counterweight_color = 'g';
crank_arm_color = 'm';
crank_shaft_color = 'k';
max_xy = (crank_l + rod_l) * 1.1;
set(gca,'XLim',[-max_xy max_xy],'YLim',[-max_xy max_xy],'XTick',[-max_xy 0 max_xy],'YTick',[-max_xy 0 max_xy]);
piston_head_location = animatedline('color',piston_head_color,'Marker','.','markersize',20);
piston_head_path = animatedline('color',piston_head_color,'LineStyle','-');
rod_com_location = animatedline('color',rod_color,'Marker','.','markersize',20);
rod_com_path = animatedline('color',rod_color,'LineStyle','-');
rod_body = animatedline('color',rod_color,'LineStyle','-');
counterweight_location = animatedline('color',counterweight_color,'Marker','.','markersize',20);
counterweight_path = animatedline('color',counterweight_color,'LineStyle','-');
counterweight_body = animatedline('color',counterweight_color,'LineStyle','-');
crank_arm_location = animatedline('color',crank_arm_color,'Marker','.','markersize',20);
crank_arm_path = animatedline('color',crank_arm_color,'LineStyle','-');
crank_rod_connection = animatedline('color',crank_arm_color,'LineStyle','-');
crank_shaft_center = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_point = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_rotation = animatedline('color',crank_shaft_color,'LineStyle','-');
addpoints(crank_shaft_center,0,0)

i = 1;
while 1
    clearpoints(piston_head_location)
    clearpoints(rod_com_location)
    clearpoints(counterweight_location)
    clearpoints(crank_arm_location)

    clearpoints(rod_body)
    clearpoints(counterweight_body)
    clearpoints(crank_rod_connection)
    clearpoints(crank_shaft_point)

    addpoints(piston_head_location,head_xy(1,i),head_xy(2,i))
    addpoints(piston_head_path,head_xy(1,i),head_xy(2,i))
    addpoints(rod_body,[head_xy(1,i) piston_crank_xy(1,i)],[head_xy(2,i) piston_crank_xy(2,i)])
    addpoints(crank_arm_location,piston_crank_xy(1,i),piston_crank_xy(2,i))
    addpoints(crank_arm_path,piston_crank_xy(1,i),piston_crank_xy(2,i))
    addpoints(crank_rod_connection,[piston_crank_xy(1,i) 0],[piston_crank_xy(2,i) 0])
    addpoints(rod_com_location,rod_xy(1,i),rod_xy(2,i))
    addpoints(rod_com_path,rod_xy(1,i),rod_xy(2,i))
    addpoints(counterweight_location,counterweight_xy(1,i),counterweight_xy(2,i))
    addpoints(counterweight_path,counterweight_xy(1,i),counterweight_xy(2,i))
    addpoints(counterweight_body,[counterweight_xy(1,i) 0],[counterweight_xy(2,i) 0])
    addpoints(crank_shaft_rotation,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_shaft_point,[crank_xy(1,i) 0],[crank_xy(2,i) 0])
    
    drawnow
    i = mod(i,n_points);
    i = i+1;
end