function status = restoreEEGOptions(backupOptionsFile, currentOptionsFile)
% This function will restore the EEGLAB options file. The backup file will
% replace the the current file. 
% 
% Input parameters:
%  backupOptionsFile         The path to the file storing a copy of the 
%                            original EEGLAB options. 
%  currentOptionsFile        The path to the file storing the original 
%                            EEGLAB options. 
%
% Output parameters:
%   status                   1 if the EEGLAB options file is restored, 0 if
%                            it is not. 

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

status = 1;
if ~isempty(currentOptionsFile) && ~isempty(backupOptionsFile)
    [status, message] = copyfile(backupOptionsFile, currentOptionsFile);
    if status
        delete(backupOptionsFile);
    else
        ME = MException('restoreEEGOptions:cannotRestore', ...
            ['Cannot restore EEG options. %s\n Backup options file\n' ...
            ' %s\n Current options file\n %s'], message, ...
            backupOptionsFile, currentOptionsFile);
        throw(ME)
    end
end % restoreEEGOptions