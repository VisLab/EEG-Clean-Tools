function optionsFile = getEEGOptionsFile()
% This function will get the location of the EEGLAB options file.
% 
% Output parameters:
%  optionsFile               The path to the file storing the 
%                            EEGLAB options. An empty string will be
%                            returned if there is no options file found. 

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
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  US
optionsFile = '';
eeglab_options;
if ~isempty(EEGOPTION_PATH)
    homefolder = EEGOPTION_PATH;
elseif ispc
    if ~exist('evalc') %#ok<EXIST>
        eval('evalc = @(x)(eval(x));');
    end
    homefolder = deblank(evalc('!echo %USERPROFILE%'));
else
    homefolder = '~';
end
location = fullfile(homefolder, 'eeg_options.m');
if exist(location, 'file')
    optionsFile = location;
end
end % getEEGOptionsFile