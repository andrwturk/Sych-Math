classdef Database < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        % matfile containing the tables.
        mf;
    end
    
    properties (Dependent, SetAccess = private)
        % The Fragment table.
        Fragment;
    end
    
    methods
        function this = Database()
            this.mf = matfile('data/database.mat', 'Writable', true);
            
            if ~isfield(this.mf, 'Fragment')
                t.Id = [];
                t.Setup = [];
                t.FileName = [];
                t.FragmentBegin = [];
                t.FragmentEnd = [];
                t.FragmentType = [];
                t.Gun = [];
                t.Distance = [];
                t.DirectionToShooter = [];
                t.DirectionOfShooting = [];
                this.Fragment = struct2table(t);
            end
        end
        
        function append(this, record)
            % Determine new record(s)' Id.
            if height(this.Fragment) > 0
                start_id = max(this.Fragment.Id);
            else
                start_id = 0;
            end
            
            for i = 1 : numel(record)
                record(i).Id = start_id + i;
            end
        
            % Insert new record(s).
            this.Fragment = [this.Fragment; struct2table(record)];
        end
        
        function val = get.Fragment(this)
            val = this.mf.Fragment;
        end
        
        function set.Fragment(this, val)
            this.mf.Fragment = val;
        end
    end
end

