%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
params = struct();
%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;
%% Specific setup
% outdir = 'N:\\ARLAnalysis\\VEPDetrend\\processedHP';
% params.detrendType = 'high pass';
% outdir = 'N:\ARLAnalysis\VEPNewTrend\VEPStandardLevel2RobustNoDetrend';
% params.detrendType = 'none';
% basenameOut = [basename '_nodetrend'];

% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrended';
% params.detrendType = 'linear';
% params.detrendCutoff = 1;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5';
% params.detrendType = 'linear';
% params.detrendCutoff = 0.5;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3';
% params.detrendType = 'high pass';
% params.detrendCutoff = 0.3;

% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2';
% params.detrendType = 'linear';
% params.detrendCutoff = 0.2;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3';
% params.detrendType = 'linear';
% params.detrendCutoff = 0.3;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored\\VEPStandardLevel2RobustHPCutoff1';
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPCutoff1';
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];


% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'specific';
% params.evaluationChannels = 1:64;
% params.referenceChannels = 69:70;
% basenameOut = [basename 'mastoid_ref_cutoff' num2str(params.detrendCutoff)];
% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2MastoidHPCutoff1';

% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'specific';
% params.evaluationChannels = 1:64;
% params.referenceChannels = 1:64;
% basenameOut = [basename 'average_ref_cutoff' num2str(params.detrendCutoff)];
% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2AverageHPCutoff1';

% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustTrendCutoff02';
% params.detrendType = 'linear';
% params.detrendCutoff = 0.2;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPSincCutoff02';
% params.detrendType = 'high pass sinc';
% params.detrendCutoff = 0.2;
% basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];

outdir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RevRobustHPCutoff0p3';
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
basenameOut = [basename 'HPRev_cutoff' num2str(params.detrendCutoff)];
%% Run the pipeline
for k = 1%:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g detrend, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.detrend, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
