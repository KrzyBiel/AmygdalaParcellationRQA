function [embeddingDim, functionEmb]=comupteDimensionPotsdam2(matrixTS, voxels, delays, maxDim)
    embeddingDim = zeros([voxels,1]); % vector for embedding dimension
    functionEmb = zeros([voxels, maxDim]); % matrix with values of functions of false nearest neighbours
    for i = 1: voxels
        ts = matrixTS(:,i); % take time series from i th voxel
        dim = fnn(ts, maxDim, delays(i), 'nogui'); % compute false nearest neighbour function
        valueDim = transpose(dim);
        functionEmb(i,:) = valueDim; % write it to matrix values of function fnn
        whatToTake = find(valueDim<=0.05);
        if length(whatToTake)>=1
            embeddingDim(i,:)=whatToTake(1);
        else
            embeddingDim(i,:)=0;
        end
    end
end