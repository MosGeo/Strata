function strata = upscaleStrata(strata, smoothingInterval)


%     classification = strata.lithology;
%     padSize = (smoothingInterval - 1) / 2;   
%     
%     B = padarray(classification,padSize,'replicate');
%     for j = 1+padSize:padSize+numel(classification)
% 
%         data = B(j-padSize: j+padSize);
%         midData = B(j);
%         uniqueData = unique(data);
%         [N] = histcounts(data,numel(uniqueData));
%         [~, I] = max(N);
%         value = uniqueData(I);
%         if N(midData == uniqueData)== N(value== uniqueData); value = midData; end
%         
%         classification(j-padSize) = value;
%     end
%     
%     strata.lithology = classification;

end