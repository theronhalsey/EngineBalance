% engine parameters
rpm = 4000;
rps = rpm/60;
p = 1/rps;

% time parameters
dt = .00001; % time increment in seconds
t = 0:dt:p-dt;

% crankshaft (assume crankshaft is balanced)
crank_l = 0.099060; % length of crank throw in meters (3.9' stroke)
f_crank_angle = @(t) 2*pi*rps.*mod(t,p);
%crank_angles = f_crank_angle(t);

% piston parameters
head_m = 1.0; % mass of piston head in kg
piston_angle = 0;

% counterweight
counterweight_m = 0.5; % mass of counterweight
counterweight_l = crank_l * 1.25; % distance to center of mass of counterweight from center of crankshaft
counterweight_offset = piston_angle + pi;

% piston rod
rod_m = 5.44311; %mass of piston rod in kg (12 lbs)
rod_l = 0.1525; % length of connecting rod in meters (6' rod)
rod_w = 0.0251; % width of connecting rod in meters

Forces = piston(p,rps,t,dt,crank_l,head_m,piston_angle,rod_m,rod_l,counterweight_m,counterweight_l,counterweight_offset);

crank_xy = Forces(1:2,:);
head_xy = Forces(3:4,:);
head_f = Forces(5:6,:);
rod_xy = Forces(7:8,:);
rod_f = Forces(9:10,:);
counterweight_xy = Forces(11:12,:);
counterweight_f = Forces(13:14,:);
total_f = head_f + rod_f + counterweight_f;

% %% Plotting
% tiledlayout(2,2);
% 
% % piston head
% nexttile
% hold on
% title("Piston Head")
% % yyaxis left
% % plot(t,head_xy(1,:),Color='b',LineStyle='-')
% % plot(t,head_xy(2,:),Color='g',LineStyle='-')
% % yyaxis right
% plot(t,head_f(1,:),Color='r',LineStyle='-')
% plot(t,head_f(2,:),Color='m',LineStyle='-')
% %legend("x-displacement","y-displacement","x-force","y-force",Location='southoutside')
% legend("x-force","y-force",Location='southoutside')
% 
% % piston rod
% nexttile
% hold on
% title("Piston Rod")
% % yyaxis left
% % plot(t,rod_xy(1,:),Color='b',LineStyle='-')
% % plot(t,rod_xy(2,:),Color='g',LineStyle='-')
% % yyaxis right
% plot(t,rod_f(1,:),Color='r',LineStyle='-')
% plot(t,rod_f(2,:),Color='m',LineStyle='-')
% %legend("x-displacement","y-displacement","x-force","y-force",Location='southoutside')
% legend("x-force","y-force",Location='southoutside')
% 
% % plot counterweight
% nexttile
% hold on
% title("Counterweight")
% % yyaxis left
% % plot(t,counterweight_xy(1,:),Color='b',LineStyle='-')
% % plot(t,counterweight_xy(2,:),Color='g',LineStyle='-')
% % yyaxis right
% plot(t,counterweight_f(1,:),Color='r',LineStyle='-')
% plot(t,counterweight_f(2,:),Color='m',LineStyle='-')
% %legend("x-displacement","y-displacement","x-force","y-force",Location='southoutside')
% legend("x-force","y-force",Location='southoutside')
% 
% % plot total force on crankshaft
% nexttile
% hold on
% title("Total Force")
% % yyaxis left
% % plot(t,crank_angles,Color='b',LineStyle='-')
% % yyaxis right
% plot(t,total_f(1,:),Color='r',LineStyle='-')
% plot(t,total_f(2,:),Color='m',LineStyle='-')
% %legend("crank angle","x-force","y-force",Location='southoutside')
% legend("x-force","y-force",Location='southoutside')

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
crank_arm_body = animatedline('color',crank_arm_color,'LineStyle','-');
crank_shaft_location = animatedline('color',crank_shaft_color,'Marker','.','markersize',20);
addpoints(crank_shaft_location,0,0)

for i=1:length(t)
    clearpoints(piston_head_location)
    clearpoints(rod_com_location)
    clearpoints(counterweight_location)
    clearpoints(crank_arm_location)

    clearpoints(rod_body)
    clearpoints(counterweight_body)
    clearpoints(crank_arm_body)

    addpoints(piston_head_location,head_xy(1,i),head_xy(2,i))
    addpoints(piston_head_path,head_xy(1,i),head_xy(2,i))
    addpoints(rod_body,[head_xy(1,i) crank_xy(1,i)],[head_xy(2,i) crank_xy(2,i)])
    addpoints(crank_arm_location,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_arm_path,crank_xy(1,i),crank_xy(2,i))
    addpoints(crank_arm_body,[crank_xy(1,i) 0],[crank_xy(2,i) 0])
    addpoints(rod_com_location,rod_xy(1,i),rod_xy(2,i))
    addpoints(rod_com_path,rod_xy(1,i),rod_xy(2,i))
    addpoints(counterweight_location,counterweight_xy(1,i),counterweight_xy(2,i))
    addpoints(counterweight_path,counterweight_xy(1,i),counterweight_xy(2,i))
    addpoints(counterweight_body,[counterweight_xy(1,i) 0],[counterweight_xy(2,i) 0])
    
    drawnow
end