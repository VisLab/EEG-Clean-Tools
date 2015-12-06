%% Example using ESS to combine folders

partFolders = {'N:\BCIT_ESS\X2 RSVP Expertise_1_28', ...
               'N:\BCIT_ESS\X2 RSVP Expertise_29_35', ...
               'N:\BCIT_ESS\X2 RSVP Expertise_36_43'};
finalFolder = 'N:\BCIT_ESS\X2 RSVP Expertise';
%% Now do the combination
obj = level2Study;
obj = obj.combinePartialLevel2Runs(partFolders, finalFolder);
            
% %% Create a level 2 study
% obj2 = level2Study('level2XmlFilePath', ess2Dir);
% obj2 = obj2.validate();
% %% Get the files out
% [filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
%     getFilename(obj2);
% 
% %% Extract the channel locations
% for k = 1:length(filenames)
%     EEG = pop_loadset(filenames{k});
%     [pathstr, name, ext] = fileparts(filenames{k});
% %     needsRewrite = false;
% %     if ~isfield(EEG.etc, 'dataRecordingUuid') || ...
% %         ~strcmpi(EEG.etc.dataRecordingUuid, dataRecordingUuids{k});
% %         EEG.etc.dataRecordingUuid = dataRecordingUuids{k};
% %         needsRewrite = true;
% %     end
% %     if ~isfield(EEG.etc, 'dataRecordingUuidHistory') || ...
% %         isempty(EEG.etc.dataRecordingUuidHistory) || ...
% %         ~iscell(EEG.etc.dataRecordingUuidHistory) || ...
% %         ~strcmpi(EEG.etc.dataRecordingUuidHistory{1}, dataRecordingUuids{k}) || ...
% %         ~strcmpi(EEG.etc.dataRecordingUuidHistory{end}, obj2.studyLevel2Files.studyLevel2File(k).uuid)
% %         EEG.etc.dataRecordingUuidHistory{1} = dataRecordingUuids{k};
% %         EEG.etc.dataRecordingUuidHistory{2} = obj2.studyLevel2Files.studyLevel2File(k).uuid; 
% %         needsRewrite = true;
% %     end
% %     if needsRewrite 
% %         fprintf('Rewriting level 2\n');
% %         save(filenames{k}, 'EEG', '-v7.3');
% %     end
%         
%     pathStart = strfind(pathstr, ess2Dir);
%     if pathStart ~= 1
%         error([path2str ' does not start with ' essDir]);
%     end
%     nextPath = pathstr(length(ess2Dir) + 2:end);
%     pathPieces = strsplit(nextPath, filesep);
%     outDir = ess2DerivedDir;
%     for j = 1:length(pathPieces);
%         outDir = [outDir filesep pathPieces{j}]; %#ok<AGROW>
%         if ~isdir(outDir)
%             mkdir(outDir);
%         end
%     end
%     fprintf('Resampling\n');
%     
%     params = struct('resampleOff', false, 'resampleFrequency', 256, ...
%         'lowPassFrequency', 100);  
%     try
%         EEG.etc.dataRecordingUuidHistory{end + 1} = ...
%             char(java.util.UUID.randomUUID);
%         [EEG, resampling] = resampleEEG(EEG, params);
%         EEG.etc.resampling = resampling;
%         EEG.etc.interpolatedChannels = EEG.etc.noiseDetection.reference.interpolatedChannels;
%         EEG.etc = rmfield(EEG.etc, 'noiseDetection');
%         EEG.etc.VersionData.STDL2 = 'STDL2_BCIT_v1.00';
%         fname = [outDir filesep name ext];
%         save(fname, 'EEG', '-mat', '-v7.3');
%     catch mex
%         errorMessages.resampling = ...
%             ['failed resampleEEG: ' getReport(mex)];
%         errorMessages.status = 'unprocessed';
%         EEG.etc.resampling.errors = errorMessages;
%         return;
%     end
%        
% end
% 
