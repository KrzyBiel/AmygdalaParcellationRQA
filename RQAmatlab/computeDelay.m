function timeDelay = computeDelay(matrixTimeSeries, minLag, maxLag, voxels)
    timeDelay = zeros(voxels,1); % create vector for timeDelays
    for i=1:voxels
        timeSeries = matrixTimeSeries(:,i); % take one time series
        if timeSeries(1)~=0
            vectorAmi = ami(timeSeries, minLag, maxLag); % compute avarage mutual information criterion to estimate time delay 
            [~,localMinAmi] = findpeaks(-vectorAmi(:,2)); % find local minima in ami
            timeDelay(i,1) = localMinAmi(1);% take first local minimum as indicator of time delay for given time series
        else
            timeDelay(i,1)=0;
        end
    end
end