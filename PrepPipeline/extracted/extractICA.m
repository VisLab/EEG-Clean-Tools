function [EEG, ICAs] = extractICA(EEG, EEG1, description, modifyEEG)
%% Extracts a structure containing an ICA decomposition based on EEG from EEG1
%  applied to EEG. (Usually EEG1 is a cleaned version of EEG)
%
%  Parameters:
%    EEG          an EEGLAB structure for which we want to apply this EEG
%    EEG1         an EEGLAB EEG structure on which ICA has been performed
%    description  a string describing the processing to obtain ICA
%    modifyEEG    if true, then the ICA decomposition is put in EEG too
%    ICAs         structure containing EEG information
%
if size(EEG.chanlocs) ~= size(EEG1.chanlocs)
    error('extractICA:ExtractionNotCompatible', ...
        'EEG and EEG1 should have the same channels');
end
ICAs = struct('setname', [],  'nbchan', EEG.nbchan, 'srate', ...
    EEG.srate, 'chanlocs', [], 'etc', [], ...
    'icaact', [], 'icasphere', [], 'icawinv', [], ...
    'icaweights', [], 'icachansind', []);
ICAs.setname = EEG.setname;
ICAs.chanlocs = EEG.chanlocs;
ICAs.icaweights = EEG1.icaweights;
ICAs.icasphere = EEG1.icasphere;
ICAs.icaact = (EEG1.icaweights*EEG1.icasphere)*EEG.data(EEG1.icachansind, :);
ICAs.icachansind = EEG1.icachansind;
ICAs.etc.icainfo = description;

if modifyEEG
    ICAs.chanlocs = EEG.chanlocs;
    EEG.icaweights = ICAs.icaweights;
    EEG.icasphere = ICAs.icasphere;
    EEG.icaact = ICAs.icaact;
    EEG.icachansind = ICAs.icachansind;
    EEG.etc.icainfo = description;
end

