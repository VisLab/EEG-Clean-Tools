function [backupOptionsFile, currentOptionsFile, warningsState] = ...
    setupForEEGLAB()
% This function will setup EEGLAB before it runs the prep pipeline. The
% setup includes supressing the warnings associated with the clear
% functions command and backing up the EEGLAB options file. The backup file
% will be stored in a temporary directory. If there is no temporary
% directory specified on the operating system then it will be stored in the
% current directory.
%
% Output parameters:
%  backupOptionsFile         The path to the file storing a copy of the
%                            original EEGLAB options. An empty string will
%                            be returned if there is no options file found.
%  currentOptionsFile        The path to the file storing the original
%                            EEGLAB options. An empty string will
%                            be returned if there is no options file found.
%  warningsState             A structure array containing the original
%                            warning state.

% Copyright (C) 2015  Kay Robbins with contributions from Nima
% Bigdely-Shamlo, Christian Kothe, Tim Mullen, Jeremy Cockfield,
% and Cassidy Matousek
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

warningsState = warning('query', 'all');
clearExecutionState = warning('query', ...
    'MATLAB:lang:cannotClearExecutingFunction');
if strcmpi('on', clearExecutionState.state)
    warning('off', 'MATLAB:lang:cannotClearExecutingFunction');
end
[backupOptionsFile, currentOptionsFile] = backupEEGOptions();
pop_editoptions('option_single', false, 'option_savetwofiles', false);
end % setupForEEGLAB