%% Example: Running the pipeline outside of ESS using the ARL shooter data.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually.

%% Read in the file and set the necessary parameters
basename = 'shooter';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir = 'O:\ARL_Data\Shooter\Shooter_Robust_1Hz_Unfiltered'; % Input data directory used for this demo
outDir = 'O:\ARL_Data\Shooter\Shooter_Robust_1Hz_PrepInfomax';

%% Get the list of files
thisList = dir(inDir);
theseNames = {thisList(:).name};
theseTypes = [thisList(:).isdir];
theseNames = theseNames(~theseTypes);

%% Iterate through the files
count = 0;
for j = 1:length(theseNames)
    ext = theseNames{j}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    thisName = [inDir filesep theseNames{j}];
    count = count + 1;
    fprintf('%d [%d]: %s\n', count, j, thisName);
    EEG = pop_loadset(thisName);
    EEG = highPassAndPrepCleanICA(EEG, 'detrendCutoff', 1.0, ...
                        'icatype', 'runica', 'extended', 0, ...
                        'fractionBad', 0.25);
    fname = [outDir filesep theseNames{j}];
    save(fname, 'EEG', '-mat', '-v7.3');
end

