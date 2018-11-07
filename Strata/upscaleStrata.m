function strataUpscaled = upscaleStrata(strata, smoothingInterval)


    classification = strata.lithology;
    padSize = (smoothingInterval - 1) / 2;
    
    B = padarray(classification,padSize,'replicate');
    for j = 1+padSize:padSize+numel(classification)
        classification(j-padSize) = mode(B(j-padSize: j+padSize));
    end

end