%% Define the path
ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
obj = level1Study(ess1File);
obj.validate();

%% Now do the processing
for k = 1:length(obj.sessionTaskInfo)
    for j=1:length(obj.sessionTaskInfo(k).dataRecording)
        %filePath = obj.sessionTaskInfo(k).dataRecording(j).filename
        outputFileName = obj.sessionTaskInfo(k).dataRecording(j).eventInstanceFile;
        filePath = [fileparts(ess1File) filesep 'session' filesep obj.sessionTaskInfo(k).sessionNumber];
        obj = writeEventInstanceFile(obj, k, j, filePath, outputFileName, true);
    end;
end
