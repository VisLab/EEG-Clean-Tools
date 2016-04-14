%% Insert ICA decomposition
%experiment = 'Experiment X2 Traffic Complexity';
experiment = 'Experiment X6 Speed Control';
levelDerivedFile = 'studyLevelDerived_description.xml';
cleanedICADir = 'O:\ARL_Data\BCIT_ESS_256Hz_0p5Hz_Cleaned_ICA_Extended';
baseICADir = 'O:\ARL_Data\BCIT_ESS_256Hz_0p5Hz_With_Clean_ICA_Extended';

%% Read the studies that need to be merged
levelDerivedDir = [baseICADir filesep experiment];
derivedXMLFile = [levelDerivedDir filesep levelDerivedFile];
obj = levelDerivedStudy('levelDerivedXmlFilePath', derivedXMLFile);
[files, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
             getFilename(obj);

%%
levelDerivedDir = [cleanedICADir filesep experiment];
derivedXMLFile = [levelDerivedDir filesep levelDerivedFile];
objCleaned = levelDerivedStudy('levelDerivedXmlFilePath', derivedXMLFile);
[filesCleaned, dataRecordingUuidsCleaned, taskLabelsCleaned, ...
    sessionNumbersCleaned, subjectsCleaned] = ...
             getFilename(objCleaned);         

%% Call the HP and ICA combination
for k = 1:length(files)
    EEG = pop_loadset(files{k});
    [myDir, myName, myExt] = fileparts(files{k});
    if sessionNumbersCleaned{k} ~= sessionNumbers{k}
        error('Session numbers for file %d do not match\n', k);
    end
    EEGCleaned = pop_loadset(filesCleaned{k});
    if isempty(EEGCleaned.icaweights)
        warning('EEGCleaned(%d) %s does not contain ICA', k, filesCleaned{k});
        continue;
    elseif size(EEG.data, 1) ~= size(EEGCleaned.data, 1) 
        warning('EEGCleaned(%d) %s does not match number of channels', k, filesCleaned{k});
        continue;
    end
    EEG.icasphere = EEGCleaned.icasphere;
    EEG.icaweights = EEGCleaned.icaweights;
    EEG.icawinv = EEGCleaned.icawinv;
    EEG.icachansind = EEGCleaned.icachansind;
    %EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
    pop_saveset(EEG, 'filename', files{k}, 'savemode', 'onefile', 'version', '7.3') 
end
