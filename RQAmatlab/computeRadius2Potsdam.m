function [radius, rqaValuesMatrix] = computeRadius2Potsdam(matrixTS, voxels, timeLag,embedDim, threshold, norm)
    maxValue = max(range(matrixTS));
    radiusValues = 0:0.05:maxValue;
    for i=1:length(radiusValues)
        rqaValuesMatrix = zeros([voxels,13]);
        radiusVector = zeros([voxels,1]);
        for j=1:voxels
            if matrixTS(1,j)~=0
                rqaValues = crqa(matrixTS(:,j), matrixTS(:,j), embedDim, timeLag(j),radiusValues(i),[], norm, 'nogui');
                if rqaValues(:,1)<threshold
                    break
                else
                    radiusVector(j,1) = rqaValues(:,1);
                    rqaValuesMatrix(j,:)=rqaValues;
                end
            else
                radiusVector(j,1) = 0.001;
                rqaValuesMatrix(j,:)=zeros([1,13]);
            end
        end
        check = radiusVector==0;
        if sum(check)==0
            radius = radiusValues(i);
            break
        end
    end
end

