% toggles for which forces to show in animation
animate = 1;
record = 1;
showHeadForces = 1;
showRodForces = 1;
showCounterweightForces = 1;
showForces = [showHeadForces showRodForces showCounterweightForces];

%% 120-degree Inline_3 Firing Order_1-2-3
engine_type = "i3_120_123";
piston_layout = 'i';
n_pistons = 3;
piston_angles = ones(1,n_pistons) * (pi/2);
crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 0; % default mass = piston head + connecting rod
EngineConfigs = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale);

%% Crossplane Inline_3 Firing Order_1-2-3
engine_type = "crossplane_i3_123";
piston_layout = 'i';
n_pistons = 3;
piston_angles = ones(1,n_pistons) * (pi/2);
crank_offsets = [0 pi/2 pi];
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1;
EngineConfigs(end+1) = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale);

%% 90-Degree Inline_4 Firing Order_1-2-3-4
engine_type = "i4_90_1234";
piston_layout = 'i';
n_pistons = 4;
piston_angles = ones(1,4) * (pi/2);
crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1;
EngineConfigs(end+1) = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale);

%% 45-Degree V_6 Firing Order_1-2-3-4-5-6
engine_type = "v6_45_123456";
piston_layout = 'v';
n_pistons = 6;
piston_angles = [ones(1,3)*(3*pi/8); ones(1,3)*(5*pi/8)];
piston_angles = piston_angles(:)';
crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
crank_offsets(2:2:end) = crank_offsets(2:2:end) + pi/4;
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1;
EngineConfigs(end+1) = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale);

% switch piston_layout
%     case 'i'
%         piston_angles = ones(1,n_pistons) * (pi/2);
%         crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
%         crank_offsets = [0 pi/2 pi];
%     case 'f'
%         piston_angles = 0:pi:pi*(n_pistons-1);
%         crank_offsets = 0:pi/(n_pistons/2):pi-pi/(n_pistons/2);
%         crank_offsets = [crank_offsets;crank_offsets];
%         crank_offsets = crank_offsets(:)' + piston_angles;
%     case 'v'
%     case 'r'
%         piston_angles = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
%         crank_offsets = 2*piston_angles;
%     otherwise
% end

for i=1:length(EngineConfigs)
    %% Calculate Forces
    [engineForces,crankshaftForces] = engine(EngineConfigs(i));

    %% Animation
    if animate
        AnimateEngine(EngineConfigs(i),engineForces,crankshaftForces,record,showForces);
    end
end