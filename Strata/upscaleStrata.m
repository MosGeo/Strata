function strata = upscaleStrataMode(strata, smoothingInterval, type)
%% UPSCALESTRATA  Upscale classificaiton
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('smoothingInterval', 'var'); smoothingInterval = 1; end
if ~exist('type', 'var'); type = 'Mode'; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');

%% Main

switch(lower(type))
    
    case 'mode'

        classification = strata.lithology;
        padSize = (smoothingInterval - 1) / 2;   

        B = padarray(classification,padSize,'replicate');
        for j = 1+padSize:padSize+numel(classification)
            classification(j-padSize) = mode(B(j-padSize: j+padSize));
        end

        strata.lithology = classification;
        
    case 'mean'
        
        classification = strata.lithology;

        
        
end

end