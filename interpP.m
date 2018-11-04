
function P = interpP(markovTM, markovTBPosition, newPosition)

    nMatrices = numel(markovTM);
    
    x = [];
    for iMatrix = 1:nMatrices
        x(:,:,iMatrix) = markovTM{iMatrix};
    end
    
    % Permute to get interpolated dimension first:
    x = permute(x,[3 1 2]);
    
    x_interp = interp1(markovTBPosition,x,newPosition);
    P = reshape(x_interp, 3,3,1);

end