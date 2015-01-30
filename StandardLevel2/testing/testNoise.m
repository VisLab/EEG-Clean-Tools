%% Testing VEP data
%% Set the parameters for generating noisy data
pop_editoptions('option_single', false, 'option_savetwofiles', false);

originalDir = 'E:\\CTAData\\VEP\';
outDir = 'N:\\ARLAnalysis\\VEPTesting\\NoiseAdded';
fileNames = {'vep_01', 'vep_06'};
deviations = [160, 1600, 16000];
fractionBad = 0.5;
%% Generate the new datasets
for j = 1:length(fileNames)
    inFileName = [originalDir filesep fileNames{j} '.set'];
    EEGOrig = pop_loadset(inFileName);
    numberFrames = size(EEGOrig.data, 2);
    numberChannels = size(EEGOrig.data, 1);
    
    for k = 1:length(deviations)
        noiseData = generateTestNoise(numberFrames, fractionBad, deviations(k));
        EEG = EEGOrig;
        EEG.data = EEG.data + repmat(noiseData, numberChannels, 1);
        outFileName = [outDir filesep fileNames{j} '_' ...
                       num2str(deviations(k)) '.set'];
        save(outFileName, 'EEG', '-mat', '-v7.3');
    end
end

    