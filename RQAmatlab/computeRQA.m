function [subDelay, embeddingdim, radius, rqaValuesMatrix] = computeRQA(filename, minLag, maxLag, embeddingdim, subDelay, threshold, norm)
    matrixTimeSeries = load(filename); % load matrix with data
    [~, voxels] = size(matrixTimeSeries);% wymiar macierzy z szeregami czasowymi 
    subDelay = mean(median(TimeDelay)); %Time Delay jako "srednia mediana" z poprzednich wynikow
    subDelay = computeDelay(matrixTimeSeries, minLag, maxLag, voxels); %compute vector with delays for every ts
    nonZeroDelay = find(subDelay~=0); % indeksy niezerowych przesuniec
    subDelay = round(mean(subDelay(nonZeroDelay))); % zaokraglona wartosc time delay dla wszystkich wokseli 
    embeddingDim = mean(mean(EmbeddingDim)) % Embedding Dimension jako "srednia srednia" z poprzednich wynikow
    [embeddingDim, functionEmb]=comupteDimensionPotsdam2(matrixTimeSeries, voxels, subDelay, maxDim);
    nonZeroDim = find(embeddingDim~=0);
    embedDim = round(mean(embeddingDim(nonZeroDim)));
    [radius, rqaValuesMatrix] = computeRadius2Potsdam(matrixTimeSeries, voxels, subDelay,embeddingdim, threshold, norm); %obliczam radius
    RPmatrix = computeRP(matrixTimeSeries, subDelay, embeddingDim, radius, norm, timePoints, voxels); %obliczam macierz RP
end