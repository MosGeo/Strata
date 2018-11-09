function strata = erodeStrata(strata)
%% ERODESTRATA  Calculates the erosion done by the erosion events
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Main

thickness = strata.thickness;

erosionLayers = find([0; thickness(2:end)]<0);
while(any(erosionLayers))

    erosionInd = erosionLayers;
    erodedInd  = erosionInd-1;
    erosionAmmount = thickness(erosionInd);

    thickness(erodedInd) =  thickness(erodedInd)+ erosionAmmount;
    thickness(erosionInd) = thickness(erosionInd) - erosionAmmount;

    erosionLayers = find([0; thickness(2:end)]<0);
end

 strata.thickness = thickness;

end