%% Testing VEP data
%% Set the parameters for generating noisy data
pop_editoptions('option_single', false, 'option_savetwofiles', false);

originalDir = 'E:\\CTAData\\VEP\';
outDir = 'N:\\ARLAnalysis\\VEPTesting\\NoiseAdded';
fileNames = {'vep_01', 'vep_06', 'vep_18'};
deviations = [160, 1600, 16000];
mastoidChannel = 69;
fractionBad = 0.5;
%% Generate the new datasets
for j = 1:length(fileNames)
    inFileName = [originalDir filesep fileNames{j} '.set'];
    EEGOrig = pop_loadset(inFileName);
    numberFrames = size(EEGOrig.data, 2);
    for k = 1:length(deviations)
        noiseData = generateTestNoise(numberFrames, fractionBad, deviations(k));
        EEG = EEGOrig;
        EEG.data(mastoidChannel, :) = ...  % Not double precision
                     EEG.data(mastoidChannel, :) + noiseData;
        outFileName = [outDir filesep fileNames{j} '_' ...
                       num2str(deviations(k)) '.set'];
        save(outFileName, 'EEG', '-mat', '-v7.3');
    end
end

    