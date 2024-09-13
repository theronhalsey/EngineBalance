%% Common Parameters
% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;
n_pistons = 2;

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
head_m = .610; % mass of piston head in kg

% piston rod
rod_m = .65317; % mass of piston rod in kg
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters

%% Individual Parameters
% piston parameters
piston_angle = [pi/4 3*pi/4];
crank_offset = piston_angle + [0 pi];

% counterweight
counterweight_m = 0.5 * ones(1,n_pistons); % mass of counterweight
counterweight_l = crank_l * 0.75 * ones(1,n_pistons); % distance to center of mass of counterweight from center of crankshaft
counterweight_offset = crank_offset + pi;

%% Calculate Piston Forces
Forces = zeros(14,n_points,n_pistons);
for i=1:n_pistons
    Forces(:,:,i) = piston(dt,crank_angles,crank_offset(i),crank_l,head_m,piston_angle(i),rod_m,rod_l,counterweight_m(i),counterweight_l(i),counterweight_offset(i));
end

% total force on crankshaft at time t
total_f = Forces(9:10,:,:) + Forces(11:12,:,:) + Forces(13:14,:,:);

% max displacement and force
max_displacement = max(abs(Forces(3:4,:,:)),[],'all') * 1.1;
max_force = max(abs(total_f),[],'all');

% scale forces to displacement
Forces(9:end,:,:) = Forces(9:end,:,:) * (max_displacement/max_force);


%% Animation
piston_head_color = 'r';
rod_color = 'b';
counterweight_color = 'g';
crank_arm_color = 'm';
crank_shaft_color = 'k';
set(gca,'XLim',[-max_displacement max_displacement],'YLim',[-max_displacement max_displacement],'XTick',[-max_displacement 0 max_displacement],'YTick',[-max_displacement 0 max_displacement]);

% lines for piston head
piston_head_location = animatedline().empty(0,n_pistons);
piston_head_path = animatedline().empty(0,n_pistons);
piston_head_force_x = animatedline().empty(0,n_pistons);
piston_head_force_y = animatedline().empty(0,n_pistons);

% lines for piston rod
rod_com_location = animatedline().empty(0,n_pistons);
rod_com_path = animatedline().empty(0,n_pistons);
rod_com_force_x = animatedline().empty(0,n_pistons);
rod_com_force_y = animatedline().empty(0,n_pistons);
rod_body = animatedline().empty(0,n_pistons);

% lines for piston counterweight
counterweight_location = animatedline().empty(0,n_pistons);
counterweight_path = animatedline().empty(0,n_pistons);
counterweight_force_x = animatedline().empty(0,n_pistons);
counterweight_force_y = animatedline().empty(0,n_pistons);

% lines for crank shaft
crank_arm_location = animatedline().empty(0,n_pistons);
crank_arm_path = animatedline().empty(0,n_pistons);

for i=1:n_pistons
    piston_head_location(i) = animatedline('color',piston_head_color,'Marker','.','markersize',20);
    piston_head_path(i) = animatedline('color',piston_head_color,'LineStyle','-');
    piston_head_force_x(i) = animatedline('color',piston_head_color,'LineStyle','-');
    piston_head_force_y(i) = animatedline('color',piston_head_color,'LineStyle','-');

    rod_com_location(i) = animatedline('color',rod_color,'Marker','.','markersize',20);
    rod_com_path(i) = animatedline('color',rod_color,'LineStyle','-');
    rod_com_force_x(i) = animatedline('color',rod_color,'LineStyle','-');
    rod_com_force_y(i) = animatedline('color',rod_color,'LineStyle','-');
    rod_body(i) = animatedline('color',rod_color,'LineStyle','-');

    counterweight_location(i) = animatedline('color',counterweight_color,'LineStyle','-','Marker','.','markersize',20);
    counterweight_path(i) = animatedline('color',counterweight_color,'LineStyle','-');
    counterweight_force_x(i) = animatedline('color',counterweight_color,'LineStyle','-');
    counterweight_force_y(i) = animatedline('color',counterweight_color,'LineStyle','-');

    crank_arm_location(i) = animatedline('color',crank_arm_color,'LineStyle','-','Marker','.','markersize',20);
    crank_arm_path(i) = animatedline('color',crank_arm_color,'LineStyle','-');
end

crank_shaft_point = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_rotation = animatedline('color',crank_shaft_color,'LineStyle','-');
crank_shaft_center = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
crank_shaft_force_x = animatedline('color',crank_shaft_color,'LineStyle','-');
crank_shaft_force_y = animatedline('color',crank_shaft_color,'LineStyle','-');
addpoints(crank_shaft_center,0,0)

i = 1;
while 1
    clearpoints(crank_shaft_point)
    clearpoints(crank_shaft_force_x)
    clearpoints(crank_shaft_force_y)
    for j=1:n_pistons
        piston_crank_xy = Forces(1:2,:,j);
        head_xy = Forces(3:4,:,j);
        rod_xy = Forces(5:6,:,j);
        counterweight_xy = Forces(7:8,:,j);
        head_f = Forces(9:10,:,j);
        rod_f = Forces(11:12,:,j);
        counterweight_f = Forces(13:14,:,j);

        clearpoints(piston_head_location(j))
        clearpoints(piston_head_force_x(j))
        clearpoints(piston_head_force_y(j))

        clearpoints(rod_com_location(j))
        clearpoints(rod_com_force_x(j))
        clearpoints(rod_com_force_y(j))
        clearpoints(rod_body(j))

        clearpoints(counterweight_location(j))
        clearpoints(counterweight_force_x(j))
        clearpoints(counterweight_force_y(j))

        clearpoints(crank_arm_location(j))

        addpoints(piston_head_location(j),head_xy(1,i),head_xy(2,i))
        addpoints(piston_head_path(j),head_xy(1,i),head_xy(2,i))
        addpoints(piston_head_force_x(j),[head_xy(1,i) head_xy(1,i)+head_f(1,i)], [head_xy(2,i) head_xy(2,i)])
        addpoints(piston_head_force_y(j),[head_xy(1,i) head_xy(1,i)], [head_xy(2,i) head_xy(2,i)+head_f(2,i)])
        addpoints(rod_body(j),[head_xy(1,i) piston_crank_xy(1,i)],[head_xy(2,i) piston_crank_xy(2,i)])
        addpoints(crank_arm_location(j),[piston_crank_xy(1,i) 0],[piston_crank_xy(2,i) 0])
        addpoints(crank_arm_path(j),piston_crank_xy(1,i),piston_crank_xy(2,i))
        addpoints(rod_com_location(j),rod_xy(1,i),rod_xy(2,i))
        addpoints(rod_com_path(j),rod_xy(1,i),rod_xy(2,i))
        addpoints(rod_com_force_x(j),[rod_xy(1,i) rod_xy(1,i)+rod_f(1,i)],[rod_xy(2,i) rod_xy(2,i)])
        addpoints(rod_com_force_y(j),[rod_xy(1,i) rod_xy(1,i)],[rod_xy(2,i) rod_xy(2,i)+rod_f(2,i)])
        addpoints(counterweight_location(j),[counterweight_xy(1,i) 0],[counterweight_xy(2,i) 0])
        addpoints(counterweight_path(j),counterweight_xy(1,i),counterweight_xy(2,i))
        addpoints(counterweight_force_x(j),[counterweight_xy(1,i) counterweight_xy(1,i)+counterweight_f(1,i)],[counterweight_xy(2,i) counterweight_xy(2,i)])
        addpoints(counterweight_force_y(j),[counterweight_xy(1,i) counterweight_xy(1,i)],[counterweight_xy(2,i) counterweight_xy(2,i)+counterweight_f(2,i)])
        addpoints(crank_shaft_force_x,[0 total_f(1,i)],[0 0])
        addpoints(crank_shaft_force_y,[0 0],[0 total_f(2,i)])
    end
    addpoints(crank_shaft_rotation,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_shaft_point,[crank_xy(1,i) 0],[crank_xy(2,i) 0])
    drawnow

    i = mod(i,n_points);
    i = i+1;
end