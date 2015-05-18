%% Example using ESS
pop_editoptions('option_single', false, 'option_savetwofiles', false);
ess2Dir = 'N:\\ARLAnalysis\\NCTU\\NCTURobust_1Hz_New';
%ess2Dir = 'N:\\ARLAnalysis\\NCTUPrepPreSession13\\NCTURobustHP1Hz';
ess2File = 'studyLevel2_description.xml';
ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
outDir = 'N:\\ARLAnalysis\\NCTU\\NCTU_1Hz';
%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% Parameters that must be preset
params = struct();
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'original';

%% Extract the channel locations
channelLocations = cell(length(filenames), 1);
for k = 1:length(filenames)
    EEG = pop_loadset(filenames{k});
    channelLocations = EEG.chanlocs;
    params = struct();
    params.detrendType = 'high pass';
    params.detrendCutoff = 1;
    params.referenceType = 'original';
    ref = EEG.etc.noiseDetection.reference;
    detrend = EEG.etc.noiseDetection.detrend;
    params.evaluationChannels = ref.evaluationChannels;
    params.referenceChannels = ref.referenceChannels;
    params.rereferencedChannels = ref.rereferencedChannels;
    params.detrendChannels = detrend.detrendChannels;
    [pathname, fname, fext] = fileparts(filenames{k});
    pieces = strsplit(pathname, '\');
    session = pieces{end};
    thisDir = [ess1Path filesep 'session' filesep session];
    thisList = dir(thisDir);
    theseNames = {thisList(:).name};
    theseTypes = [thisList(:).isdir];
    theseNames = theseNames(~theseTypes);
    for j = 1:length(theseNames)
        ext = theseNames{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        infile = [thisDir filesep theseNames{j}];
        EEG = pop_loadset(infile);
        EEG.chanlocs = channelLocations;
        EEG.data = double(EEG.data);
        %     refSignal = nanmean(EEG.data(params.referenceChannels, :), 1);
        %     EEG = removeReference(EEG, refSignal, params.rereferencedChannels);
        [EEG, params.detrend]  = removeTrend(EEG, params);
        params.referenceSignal = [];
        params.noisyOut = findNoisyChannels(EEG, params);
        EEG.etc.originalReference = params;
        outName = [outDir filesep fname fext];
        save(outName, 'EEG', '-mat', '-v7.3');
    end
end   
