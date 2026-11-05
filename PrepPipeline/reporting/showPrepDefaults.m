function showPrepDefaults(EEG, FID)
% Displays information about the defaults used for PREP pipeline steps
%
% Parameters:
%     EEG         a structure compatible with EEGLAB EEG structure
%     FID         (optional) an open file descriptor indication which
%                 file to output to. By default, this is the console
%                 or command window

%%
types = {'boundary', 'resample', 'globaltrend', 'detrend', ...
                'linenoise', 'reference', 'report', 'postprocess'};
if nargin < 1 || ~isstruct(EEG)
    error('showPrepDefaults:NotEnoughArguments', ...
         'first argument must be a structure');
elseif nargin < 2 || ~exist('FID', 'var')  
    FID = 1;
end

indent = '  ';
for k = 1:length(types)
    theseDefaults = getPrepDefaults(EEG, types{k});
    theseFields = fieldnames(theseDefaults);
    fprintf(FID, '\nDefaults for %s:\n', types{k});
    for j = 1:length(theseFields)
        printNext(theseFields{j}, theseDefaults.(theseFields{j}));
    end
end

    function printNext(theField, theStruct)
       fprintf(FID, '%s%s:\n', indent, theField);
       fprintf(FID, '%s%svalue: %s\n', indent, indent, ...
           getString(theStruct.value));
       fprintf(FID, '%s%sclasses: %s\n', indent, indent, ...
           getString(theStruct.classes));
       fprintf(FID, '%s%sattributes: %s\n', indent, indent, ...
           getString(theStruct.attributes));
       fprintf(FID, '%s%sdescription:\n', indent, indent);
       printLines(FID, theStruct.description, 80, [indent indent indent]);
    end
end