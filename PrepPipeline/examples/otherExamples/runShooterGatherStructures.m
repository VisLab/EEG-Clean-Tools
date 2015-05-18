%% Gathers noisyStatistics from different versions of the shooter data for
% comparison. The results is collated in a noisyStatistics structure.

%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

averageDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Average_1Hz';
mastoidDir = 'N:\ARLAnalysis\Shooter\Shooter_Mastoid_1Hz';
robustDir = 'N:\\ARLAnalysis\\Shooter\\ShooterRobust_1Hz_Unfiltered'; 
outDir = 'N:\\ARLAnalysis\\Shooter';
%% Parameters that must be preset
inList = dir(mastoidDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
numFiles = 0;
for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    numFiles = numFiles + 1;
end
  
noisyStatistics(numFiles) = struct('original', [], 'mastoid', [], 'average', [], ...
                  'robustOriginal', [], 'robustBeforeInterpolation', [], ...
                  'robustFinal', []);

%% Get a list of the files in the mastoid reference
inList = dir(mastoidDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fname = [mastoidDir filesep inNames{k}];
    EEG = pop_loadset(fname);
    noisyStatistics(k).mastoid = EEG.etc.mastoidReference.noisyOut;
end   

%% Get a list of the files in the average reference
inList = dir(averageDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fname = [averageDir filesep inNames{k}];
    EEG = pop_loadset(fname);
    noisyStatistics(k).average = EEG.etc.averageReference.noisyOut;
end 

%% Get a list of the files in the robust reference
inList = dir(robustDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fname = [robustDir filesep inNames{k}];
    EEG = pop_loadset(fname);
    ref = EEG.etc.noiseDetection.reference;
    noisyStatistics(k).robustOriginal = ref.noisyStatisticsOriginal;
    noisyStatistics(k).robustBeforeInterpolation = ref.noisyStatisticsBeforeInterpolation;
    noisyStatistics(k).robustFinal = ref.noisyStatistics;
end   

%% Save the gathered statistics in a file
summaryName = [outDir filesep 'Shooter_Summary.mat'];
save(summaryName, 'noisyStatistics', '-v7.3')
