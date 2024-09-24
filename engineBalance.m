piston_layouts = ['i','f','v','r'];
piston_layout = piston_layouts(1);
n_pistons = 3;

switch piston_layout
    case 'i'
        piston_angles = ones(1,n_pistons) * (pi/2);
        crank_offsets = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
    case 'f'
        piston_angles = 0:pi:pi*(n_pistons-1);
        crank_offsets = 0:pi/(n_pistons/2):pi-pi/(n_pistons/2);
        crank_offsets = [crank_offsets;crank_offsets];
        crank_offsets = crank_offsets(:)' + piston_angles;
    case 'v'
    case 'r'
        piston_angles = linspace(0,2*pi*(1-1/n_pistons),n_pistons);
        crank_offsets = 2*piston_angles;
    otherwise
end

[engineForces,crankshaftForces] = engine(n_pistons,piston_layout,piston_angles,crank_offsets);