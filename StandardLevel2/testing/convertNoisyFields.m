%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% BCIT datasets
% indir = 'O:\BCIT\Level2MastoidReference\T1'; % Input data directory used for this demo
% outdir = 'K:\\CTAData\\BCIT\\Level2MastoidReference\\T1';
% referenceType = 'specific';

%% VEP datasets
% indir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReference';
% outdir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReference';
% referenceType = 'average';

% indir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoid';
% outdir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReferenceAfterMastoid';
% referenceType = 'average';

% indir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReference';
% outdir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidReference';
% referenceType = 'specific';

% indir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidBefore';
% outdir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBefore';
% referenceType = 'specific';

% indir = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2Robust';
% outdir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2Robust';
% referenceType = 'robust';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITStandardLevel2Robust\\T1';
% outdir = 'N:\\ARL_BCIT_Program\\BCITStandardLevel2Robust\\T1';
% referenceType = 'robust';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITStandardLevel2Robust\\T2';
% outdir = 'N:\\ARL_BCIT_Program\\BCITStandardLevel2Robust\\T2';
% referenceType = 'robust';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITStandardLevel2Robust\\T3';
% outdir = 'N:\\ARL_BCIT_Program\\BCITStandardLevel2Robust\\T3';
% referenceType = 'robust';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITSpecificLevel2Mastoid\\T1';
% outdir = 'N:\\ARL_BCIT_Program\\BCITSpecificLevel2Mastoid\\T1';
% referenceType = 'specific';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITSpecificLevel2Mastoid\\T2';
% outdir = 'N:\\ARL_BCIT_Program\\BCITSpecificLevel2Mastoid\\T2';
% referenceType = 'specific';

% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITSpecificLevel2Mastoid\\T3';
% outdir = 'N:\\ARL_BCIT_Program\\BCITSpecificLevel2Mastoid\\T3';
% referenceType = 'specific';
% 
% indir = 'N:\\ARL_BCIT_ProgramOld\\BCITSpecificLevel2Average\\T1';
% outdir = 'N:\\ARL_BCIT_Program\\BCITSpecificLevel2Average\\T1';
% referenceType = 'specific';

indir = 'N:\\ARL_BCIT_ProgramOld\\BCITSpecificLevel2Average\\T2';
outdir = 'N:\\ARL_BCIT_Program\\BCITSpecificLevel2Average\\T2';
referenceType = 'average';
%% Get a list of the files from the input directory
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);

for k = 1:length(in_names) 
    ext = in_names{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fname = [indir filesep in_names{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG = fixNoisyFields(EEG, referenceType);
    fname = [outdir filesep in_names{k}];
    save(fname, 'EEG', '-mat', '-v7.3');
end