function errorStatus = getErrors(noiseDetection)
% Returns cell array of error msgs in the PREP noiseDetection field  
%
% Parameters:
%    noiseDetection   PREP noiseDetection structure 
%    errorStatus      (output) cell array with error status and messages
%
% Example:
%          errorStatus = getErrors(EEG.etc.noiseDetection)
%
% Written by: Kay Robbins, UTSA 2015
%

%% Report overall status
if isempty(noiseDetection) || ~isa(noiseDetection, 'struct') || ...
   ~isfield('noiseDetection', 'errors') || ...
   ~isa(noiseDetection.errors, 'struct') || ...
   ~isfield(noiseDetection.errors, 'status')
  errorStatus = {'Error status: invalid PREP noiseDetection structure'};
  return;
else  
   errorStatus = {'Error status: ' noiseDetection.errors.status};
end

%% Include any errors on boundary handling
if ~isfield(noiseDetection.errors, 'boundary')
    errorStatus{end+1} = 'Boundary errors: [not included]';
else errorStatus{end+1} = ...
        ['Boundary errors: [' noiseDetection.errors.boundary ']'];
end   

%% Include any errors on detrend (filtering)
if ~isfield(noiseDetection.errors, 'detrend')
    errorStatus{end+1} = 'Detrend errors: [not included]';
else errorStatus{end+1} = ...
        ['Detrend errors: [' noiseDetection.errors.detrend ']'];
end   

%% Include any errors on lineNoise
if ~isfield(noiseDetection.errors, 'lineNoise')
    errorStatus{end+1} = 'Line noise errors: [not included]';
else errorStatus{end+1} = ...
        ['Line noise errors: [' noiseDetection.errors.lineNoise ']'];
end   

%% Include any errors on referencing
if ~isfield(noiseDetection.errors, 'reference')
    errorStatus{end+1} = 'Reference errors: [not included]';
else errorStatus{end+1} = ...
        ['Reference errors: [' noiseDetection.errors.reference ']'];
end   

