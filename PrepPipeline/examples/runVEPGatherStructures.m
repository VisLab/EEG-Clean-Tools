%% Gathers noisyStatistics from different versions of the VEP data for
% comparison. The results is collated in a noisyStatistics structure.

%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);
basename = 'vep';
averageDir = 'N:\\ARLAnalysis\\VEP\\VEPAverage_1Hz';
mastoidDir = 'N:\\ARLAnalysis\\VEP\\VEPMastoid_1Hz';
originalDir = 'N:\\ARLAnalysis\\VEP\\VEP_1Hz';
robustDir = 'N:\\ARLAnalysis\\VEP\\VEPRobust_1Hz_Post_Median_Unfiltered'; 
outDir = 'N:\\ARLAnalysis\\VEP';
%% Parameters that must be preset
numFiles = 18;
noisyStatistics(numFiles) = struct('original', [], 'mastoid', [], 'average', [], ...
                  'robustOriginal', [], 'robustBeforeInterpolation', [], ...
                  'robustFinal', []);

%% Get a list of the files in the mastoid reference
for k = 1:numFiles
    thisName = sprintf('%s_%02d', basename, k);
    fname = [mastoidDir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    noisyStatistics(k).mastoid = EEG.etc.mastoidReference.noisyOut;
end

%% Get a list of the files in the original reference
for k = 1:numFiles
    thisName = sprintf('%s_%02d', basename, k);
    fname = [originalDir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    noisyStatistics(k).original = EEG.etc.originalReference.noisyOut;
end 

%% Get a list of the files in the average reference
for k = 1:numFiles
    thisName = sprintf('%s_%02d', basename, k);
    fname = [averageDir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    noisyStatistics(k).average = EEG.etc.averageReference.noisyOut;
end   


%% Get a list of the files in the robust reference
for k = 1:numFiles
    thisName = sprintf('%s_%02d', basename, k);
    fname = [robustDir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    ref = EEG.etc.noiseDetection.reference;
    noisyStatistics(k).robustOriginal = ref.noisyStatisticsOriginal;
    noisyStatistics(k).robustBeforeInterpolation = ref.noisyStatisticsBeforeInterpolation;
    noisyStatistics(k).robustFinal = ref.noisyStatistics;
end   

%% Save the gathered statistics in a file
summaryName = [outDir filesep 'VEP_Summary.mat'];
save(summaryName, 'noisyStatistics', '-v7.3')
