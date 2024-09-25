% toggles for which forces to show in animation
animate = 1;
record = 1;
showHeadForces = 1;
showRodForces = 1;
showCounterweightForces = 1;

piston_layouts = ['i','f','v','r'];

%% 120-degree inline 3
% engine_type = "120_i3";
% mkdir(output_path + engine_type)
% piston_layout = piston_layouts(1);
% n_pistons = 3;
% piston_angles = ones(1,n_pistons) * (pi/2);
% crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
% counterweight_offsets = crank_offsets + pi;
% counterweight_scale = 0; % default mass = piston head + connecting rod

%% crossplane inline 3
engine_type = "crossplane_i3";
mkdir(output_path + engine_type)
piston_layout = piston_layouts(1);
n_pistons = 3;
piston_angles = ones(1,n_pistons) * (pi/2);
crank_offsets = [0 pi/2 pi];
counterweight_offsets = crank_offsets + pi;
counterweight_scale = 1; % default mass = piston head + connecting rod

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
[engineForces,crankshaftForces] = engine(n_pistons,piston_layout,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale);

%% Animation
if animate
    AnimateEngine(engine_type,n_pistons,engineForces,crankshaftForces,record,showHeadForces,showRodForces,showCounterweightForces);
end