function [TimeDelay, EmbeddingDim, RadiusValuesSubjects]=performRQA(directory, minLag, maxLag, maxDim, threshold, norm, targetDirectory, parametersDirectory)
    allDirectories = dir(directory);
    cellDirectories = {allDirectories.name};
    cellDirectories = cellDirectories(1,4:end);
    [~,subjects] = size(cellDirectories); %definiuje liczbe subjectow
    dirTS1 = strcat(directory,'/',cellDirectories(1,1));
    disp(char(dirTS1))
    matrixTS = load(char(dirTS1));
    [~, voxels] = size(matrixTS); %definiuje liczbe voxeli
    TimeDelay=zeros(subjects, voxels); %tworze macierz z zer, do ktorej zapisywac bede wartosci Time Delay
    EmbeddingDim=zeros(subjects, voxels); %tworze macierz z zer, do ktorej bede zapisywac wartosci Embedding Dimension
    RadiusValuesSubjects = zeros(subjects);
    
    for i = 1:subjects
        disp(i)
        dirTS = strcat(directory,'/',cellDirectories(1,i));
        matrixTimeSeries = load(char(dirTS)); %tworze macierze z plikow znajdujacych sie w folderze
        subDelay= computeDelay(matrixTimeSeries, minLag, maxLag, voxels); %obliczam Time Delay i zapisuje wyniki do macierzy
        TimeDelay(i, :) = subDelay; %przypisuje wartosci Time Delay do macierzy
        [EmbeddingDim(i,:),~] = comupteDimensionPotsdam2(matrixTimeSeries, voxels, subDelay, maxDim); %obliczam Embedding Dimension i zapisuje wyniki do macierzy
    end
    
    meanEmbedDim = round(mean(EmbeddingDim)); %sredni Embedding Dimension
    
    for i = 1:subjects
        disp(i)
        dirTS = strcat(directory,'/',cellDirectories(1,i));
        matrixTimeSeries = load(char(dirTS));
        [radius, ~] = computeRadius2Potsdam(matrixTimeSeries, voxels, TimeDelay(i, :),meanEmbedDim, threshold, norm);
        RadiusValuesSubjects(i)=radius;
    end
    
    meanRadiusValue = min(RadiusValuesSubjects);
    
    for i=1:subjects
        disp(i)
        dirTS = strcat(directory,'/',cellDirectories(1,i));
        matrixTimeSeries = load(char(dirTS));
        rqaValuesMatrix = zeros(voxels,13);
        for j=1:voxels
            rqaValues = crqa(matrixTimeSeries(:,j), matrixTimeSeries(:,j), meanEmbedDim, TimeDelay(i, j), meanRadiusValue,[], norm, 'nogui');
            rqaValuesMatrix(j,:) = rqaValues;
        end
        subjectID = regexp(cellDirectories(1,i),'sub-010\d{3}','match');
        rqaTargetDirectory = strcat(targetDirectory,'/',string(subjectID),'_rqa_',string(threshold),'_',norm,'.mat');
        save(rqaTargetDirectory, 'meanEmbedDim', 'rqaValuesMatrix', 'meanRadiusValue', 'TimeDelay');
        clear rqaValuesMatrix
    end
    
    save(parametersDirectory, 'TimeDelay', 'EmbeddingDim', 'RadiusValuesSubjects');
    
end
    
    %TimeDelayHistogram = histogram(TimeDelay) %rysuje histogram wartosci z macierzy Time Delay
    %EmbeddingDimHistogram = histogram(EmbeddingDim) %rysuje histogram wartosci z macierzy Embedding Dimension
    %TimeDelayMean = mean(TimeDelay); %obliczam srednia z macierzy z wartosciami Time Delay
    %TimeDelayMedian = median(TimeDelay) %obliczam mediane z macierzy z wartosciami Time Delay
    %EmbeddingDimMean = mean(EmbeddingDim); %obliczam srednia z macierzy z wartosciami Embedding Dimension
    %EmbeddingDimMedian = median(EmbeddingDim) %obliczam mediane z macierzy w wartosciami Embedding Dimension
       
%end
