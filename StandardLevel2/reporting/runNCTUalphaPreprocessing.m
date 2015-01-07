%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'N:\\ARLAnalysis\\NCTU\\Level2H'; % Input data directory used for this demo
outdir = 'N:\\ARLAnalysis\\NCTU\\AlphaPreprocessing';
numDatasets = 80;
%% Read in the NCTU preprocessed data and consolidate
fileList = cell(numDatasets, 1);
for k = 1:numDatasets
    dirName = [indir filesep 'session' filesep' num2str(k)];
    inList = dir(dirName);
    in_names = {inList(:).name};
    in_types = [inList(:).isdir];
    in_names = in_names(~in_types);
    for j = 1:length(in_names)
        ext = in_names{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        fileList{k} = [dirName filesep in_names{j}];
    end
end
%% Consolidate the results in a single structure for comparative analysis
badFiles = {};
badReasons = {};
for k = 1:length(fileList)
    try    % Ignore non EEG files
        fprintf('%d: ', k);
        EEG = pop_loadset(fileList{k});
        % Filtering at 40 Hz to get fall-off before 60 Hz
        EEG = pop_eegfiltnew(EEG, [], 40, 166, 0, []);
        EEG = pop_resample(EEG, 250);
        EEG.etc.postProcessing = ...
            {'pop_eegfiltnew(EEG, [], 40, 166, 0, [])';
             'pop_resample(EEG, 250)'};
        save([outdir filesep in_names{k}], 'EEG', '-v7.3');
    catch Mex
        badFiles{end+1} = fileList{k};  %#ok<SAGROW>
        badReasons{end+1} = Mex.message;  %#ok<SAGROW>
        continue;
    end   
end