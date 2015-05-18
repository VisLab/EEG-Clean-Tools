%% Gathers noisyStatistics from different versions of the NCTU data for
% comparison. The results is collated in a noisyStatistics structure.
pop_editoptions('option_single', false, 'option_savetwofiles', false);
ess2Dir = 'N:\\ARLAnalysis\\NCTU\\NCTURobust_1Hz_New';
ess2File = 'studyLevel2_description.xml';
averageDir = 'N:\\ARLAnalysis\\NCTU\\NCTU_Average_1Hz';
mastoidDir = 'N:\\ARLAnalysis\\NCTU\\NCTU_1Hz';
averageDirOld = 'N:\\ARLAnalysis\\NCTU\\NCTU_Average_1Hz_Old';
%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);
numFiles = length(filenames);
%% Parameters that must be preset
noisyStatistics(numFiles) = struct('original', [], 'mastoid', [], 'average', [], ...
                  'robustOriginal', [], 'robustBeforeInterpolation', [], ...
                  'robustFinal', []);

%% Extract the robust versions
for k = 1:length(filenames)
    EEG = pop_loadset(filenames{k});
    ref = EEG.etc.noiseDetection.reference;
    noisyStatistics(k).robustOriginal = ref.noisyStatisticsOriginal;
    noisyStatistics(k).robustBeforeInterpolation = ref.noisyStatisticsBeforeInterpolation;
    noisyStatistics(k).robustFinal = ref.noisyStatistics;
end

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
    noisyStatistics(k).mastoid = EEG.etc.originalReference.noisyOut;
end   

%% Get a list of the files in the average reference
inList = dir(averageDirOld);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fname = [averageDirOld filesep inNames{k}];
    EEG = pop_loadset(fname);
    noisyStatistics(k).average = EEG.etc.originalReference.noisyOut;
    %EEG.etc.averageReference = EEG.etc.originalReference;
    %EEG.etc = rmfield(EEG.etc, 'originalReference');
    %fnameNew = [averageDir filesep inNames{k}];
    %save(fnameNew, 'EEG', '-v7.3');
end  

%%
save('NCTU_Summary.mat', 'noisyStatistics', '-v7.3')