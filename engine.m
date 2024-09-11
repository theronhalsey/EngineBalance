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
piston_angle = linspace(0,2*pi,n_pistons+1);
piston_angle = piston_angle(1:end-1);
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

%% Animation
piston_head_color = 'r';
rod_color = 'b';
counterweight_color = 'g';
crank_arm_color = 'm';
crank_shaft_color = 'k';
max_xy = (crank_l + rod_l) * 1.1;
set(gca,'XLim',[-max_xy max_xy],'YLim',[-max_xy max_xy],'XTick',[-max_xy 0 max_xy],'YTick',[-max_xy 0 max_xy]);

piston_head_location = animatedline().empty(0,n_pistons);
piston_head_path = animatedline().empty(0,n_pistons);
rod_com_location = animatedline().empty(0,n_pistons);
rod_com_path = animatedline().empty(0,n_pistons);
rod_body = animatedline().empty(0,n_pistons);
counterweight_location = animatedline().empty(0,n_pistons);
counterweight_path = animatedline().empty(0,n_pistons);
counterweight_body = animatedline().empty(0,n_pistons);
crank_arm_location = animatedline().empty(0,n_pistons);
crank_arm_path = animatedline().empty(0,n_pistons);
crank_rod_connection = animatedline().empty(0,n_pistons);


for i=1:n_pistons
    piston_head_location(i) = animatedline('color',piston_head_color,'Marker','.','markersize',20);
    piston_head_path(i) = animatedline('color',piston_head_color,'LineStyle','-');
    rod_com_location(i) = animatedline('color',rod_color,'Marker','.','markersize',20);
    rod_com_path(i) = animatedline('color',rod_color,'LineStyle','-');
    rod_body(i) = animatedline('color',rod_color,'LineStyle','-');
    counterweight_location(i) = animatedline('color',counterweight_color,'Marker','.','markersize',20);
    counterweight_path(i) = animatedline('color',counterweight_color,'LineStyle','-');
    counterweight_body(i) = animatedline('color',counterweight_color,'LineStyle','-');
    crank_arm_location(i) = animatedline('color',crank_arm_color,'Marker','.','markersize',20);
    crank_arm_path(i) = animatedline('color',crank_arm_color,'LineStyle','-');
    crank_rod_connection(i) = animatedline('color',crank_arm_color,'LineStyle','-');
end

crank_shaft_point = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_rotation = animatedline('color',crank_shaft_color,'LineStyle','-');
crank_shaft_center = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
addpoints(crank_shaft_center,0,0)

i = 1;
while 1
    clearpoints(crank_shaft_point)
    for j=1:n_pistons
        piston_crank_xy = Forces(1:2,:,j);
        head_xy = Forces(3:4,:,j);
        head_f = Forces(5:6,:,j);
        rod_xy = Forces(7:8,:,j);
        rod_f = Forces(9:10,:,j);
        counterweight_xy = Forces(11:12,:,j);
        counterweight_f = Forces(13:14,:,j);
        total_f = head_f + rod_f + counterweight_f;

        clearpoints(piston_head_location(j))
        clearpoints(rod_com_location(j))
        clearpoints(counterweight_location(j))
        clearpoints(crank_arm_location(j))

        clearpoints(rod_body(j))
        clearpoints(counterweight_body(j))
        clearpoints(crank_rod_connection(j))
        

        addpoints(piston_head_location(j),head_xy(1,i),head_xy(2,i))
        addpoints(piston_head_path(j),head_xy(1,i),head_xy(2,i))
        addpoints(rod_body(j),[head_xy(1,i) piston_crank_xy(1,i)],[head_xy(2,i) piston_crank_xy(2,i)])
        addpoints(crank_arm_location(j),piston_crank_xy(1,i),piston_crank_xy(2,i))
        addpoints(crank_arm_path(j),piston_crank_xy(1,i),piston_crank_xy(2,i))
        addpoints(crank_rod_connection(j),[piston_crank_xy(1,i) 0],[piston_crank_xy(2,i) 0])
        addpoints(rod_com_location(j),rod_xy(1,i),rod_xy(2,i))
        addpoints(rod_com_path(j),rod_xy(1,i),rod_xy(2,i))
        addpoints(counterweight_location(j),counterweight_xy(1,i),counterweight_xy(2,i))
        addpoints(counterweight_path(j),counterweight_xy(1,i),counterweight_xy(2,i))
        addpoints(counterweight_body(j),[counterweight_xy(1,i) 0],[counterweight_xy(2,i) 0])
        
    end

    addpoints(crank_shaft_rotation,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_shaft_point,[crank_xy(1,i) 0],[crank_xy(2,i) 0])

    drawnow
    i = mod(i,n_points);
    i = i+1;
end