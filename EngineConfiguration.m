classdef EngineConfiguration
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

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
            obj.engine_type = engine_type;
            obj.piston_layout = piston_layout;
            obj.n_pistons = n_pistons;
            obj.piston_angles = piston_angles;
            obj.crank_offsets = crank_offsets;
            obj.counterweight_offsets = counterweight_offsets;
            obj.counterweight_scale = counterweight_scale;
            makeOutputDir(obj,output_path);
        end

        function success = makeOutputDir(obj,output_path)
            exists = isfolder(output_path + obj.engine_type);
            if ~exists
                success = mkdir(output_path + obj.engine_type);
            else
                success = exists;
            end
        end
    end
end