classdef Database < handle
    % Provides access to the recordings and metadata.
    
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
            
            if isempty(who(this.mf, 'Fragment'))
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
        
        %
        % Append a Fragment record to the database.
        %
        function append(this, record)
            % Determine new record(s)' Id.
            if height(this.Fragment) > 0
                start_id = max(this.Fragment.Id);
            else
                start_id = 0;
            end
            
            for i = 1 : numel(record)
                record(i).Id = start_id + i;
                
                for f = fieldnames(record)'
                    if ischar(record(i).(f{1}))
                        record(i).(f{1}) = {record(i).(f{1})};
                    end
                end
            end
        
            % Insert new record(s).
            this.Fragment = [this.Fragment; struct2table(record)];
        end
        
        % Get audio data for a given Fragment.Id
        function [data, fs] = getAudioData(this, fragment_id)
            rec = this.Fragment(this.Fragment.Id == fragment_id, :);
            if height(rec) > 1
                error('Multiple fragments with Id=%d found! The database is in an inconsistent state!', fragment_id);
            end
            
            if height(rec) < 1
                error('No Fragment with Id=%d found.', fragment_id);
            end
            
            [data, fs] = read_data(rec.FileName{1}, [rec.FragmentBegin + 1, rec.FragmentEnd]);
        end
        
        function val = get.Fragment(this)
            val = this.mf.Fragment;
        end
        
        function set.Fragment(this, val)
            this.mf.Fragment = val;
        end
    end
end

