classdef EngineConfiguration
    properties
        engine_type
        piston_layout
        n_pistons
        piston_angles
        crank_offsets
        counterweight_offsets
        counterweight_scale
    end

    methods
        function obj = EngineConfiguration(engine_type,piston_layout,n_pistons,piston_angles,crank_offsets,counterweight_offsets,counterweight_scale,output_path)
            arguments
                engine_type {mustBeNonzeroLengthText}
                piston_layout {mustBeMember(piston_layout,['i','f','v','r'])}
                n_pistons {mustBeInteger, mustBeGreaterThan(n_pistons,0)}
                piston_angles {mustBeRow, mustBeReal, mustEqualNumPistons(piston_angles,n_pistons)}
                crank_offsets {mustBeRow, mustBeReal, mustEqualNumPistons(crank_offsets,n_pistons)}
                counterweight_offsets {mustBeRow, mustBeReal, mustEqualNumPistons(counterweight_offsets,n_pistons)}
                counterweight_scale {mustBeReal, mustBeInRange(counterweight_scale,0,1)}
                output_path {mustBeNonzeroLengthText} = "Engines\"
            end
            obj.engine_type = engine_type;
            obj.piston_layout = piston_layout;
            obj.n_pistons = n_pistons;
            obj.piston_angles = piston_angles;
            obj.crank_offsets = crank_offsets;
            obj.counterweight_offsets = counterweight_offsets;
            obj.counterweight_scale = counterweight_scale;
            makeOutputDir(obj,output_path);
        end
    end
end

%% Custom Validation Functions
% Validate length of input vectors
function mustEqualNumPistons(v,n)
if ~isequal(length(v),n)
    msg = "Length must equal number of pistons";
    error(msg)
end
end

% Validate output directoy exists or was successfully created
function makeOutputDir(obj,output_path)
success = isfolder(output_path + obj.engine_type);
if ~success
    success = mkdir(output_path + obj.engine_type);
end
if ~success
    error("Failed to make output directory")
end
end