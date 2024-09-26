% toggles for which forces to show in animation
animate = 1;
record = 1;
showHeadForces = 1;
showRodForces = 1;
showCounterweightForces = 1;
showForces = [showHeadForces showRodForces showCounterweightForces];
output_path = "Engines\";

piston_layouts = ['i','f','v','r'];

%% 120-degree Inline_3 Firing Order_1-2-3
engine_type = "i3_120_123";
piston_layout = piston_layouts(1);
n_pistons = 3;
piston_angles = ones(1,n_pistons) * (pi/2);
crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 0; % default mass = piston head + connecting rod
i3_120_123 = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale,output_path);

%% Crossplane Inline_3 Firing Order_1-2-3
engine_type = "crossplane_i3_123";
piston_layout = piston_layouts(1);
n_pistons = 3;
piston_angles = ones(1,n_pistons) * (pi/2);
crank_offsets = [0 pi/2 pi];
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1; % default mass = piston head + connecting rod
crossplane_i3_123 = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale,output_path);

%% 90-Degree Inline_4 Firing Order_1-2-3-4
engine_type = "i4_90_1234";
piston_layout = piston_layouts(1);
n_pistons = 4;
piston_angles = ones(1,4) * (pi/2);
crank_offsets = linspace(0,2*pi*(1-1/4),4);
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1; % default mass = piston head + connecting rod
i4_90_1234 = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale,output_path);

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

%% Calculate Forces
[engineForces,crankshaftForces] = engine(i3_120_123);

%% Animation
if animate
    AnimateEngine(i3_120_123,engineForces,crankshaftForces,record,output_path,showForces);
end