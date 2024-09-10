function pistonForces = piston(dt,crank_angles,crank_offset,crank_l,head_m,piston_angle,rod_m,rod_l,counterweight_m,counterweight_l,counterweight_offset)

%% Calculate Angles and Displacement
offset_crank_angles = crank_angles + crank_offset;
aR = offset_crank_angles - piston_angle; % angles opposite piston rod
aC = asin((crank_l/rod_l) * sin(aR)); % angles opposite the crank arm
aS = pi - aR - aC; % angles opposite the piston stroke
head_displacement = sqrt(crank_l^2 + rod_l^2 - 2*crank_l*rod_l * cos(aS));
crank_xy = crank_l .* [cos(offset_crank_angles); sin(offset_crank_angles)]; % calculate the [x;y] positions of the crank arm end at time t

%% Calculate Forces
% piston head
head_xy = head_displacement .* [cos(piston_angle); sin(piston_angle)]; % piston head displacement along stroke
head_v = [diff(head_xy(1,:)); diff(head_xy(2,:))]/dt; % piston head velocity
head_a = [diff(head_v(1,:)); diff(head_v(2,:))]/dt; % piston head acceleration
head_f = head_m*head_a; % piston head force

% piston rod
rod_xy = (head_xy+crank_xy)/2;
rod_v = [diff(rod_xy(1,:)); diff(rod_xy(2,:))]/dt;
rod_a = [diff(rod_v(1,:)); diff(rod_v(2,:))]/dt;
rod_f = rod_m*rod_a;

% counterweight
counterweight_xy = counterweight_l * [cos(crank_angles + counterweight_offset); sin(crank_angles + counterweight_offset)];
counterweight_v = [diff(counterweight_xy(1,:)); diff(counterweight_xy(2,:))]/dt;
counterweight_a = [diff(counterweight_v(1,:)); diff(counterweight_v(2,:))]/dt;
counterweight_f = counterweight_m*counterweight_a;

%% Generate Output Matrix
pistonForces = [crank_xy(:,1:end-2); head_xy(:,1:end-2); [head_f(:,end-1:end) head_f(:,1:end-2)]; rod_xy(:,1:end-2); [rod_f(:,end-1:end) rod_f(:,1:end-2)]; counterweight_xy(:,1:end-2); [counterweight_f(:,end-1:end) counterweight_f(:,1:end-2)]];
end