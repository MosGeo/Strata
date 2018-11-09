function strata = removeErodedStrata(strata)
%% REMOVEERODEDSTRATA  Remove eroded layers
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Main

erodedlayersInd = strata.thickness <=0;
strata(erodedlayersInd,:)=[];

end