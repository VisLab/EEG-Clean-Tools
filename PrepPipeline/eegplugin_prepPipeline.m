% eegplugin_prepPipeline() - a wrapper to the prepPipeline, which does early stage
% 
% Usage:
%   >> eegplugin_prepPipeline(fig, try_strings, catch_strings);
%
%   see also: prepPipeline

% Author: Kay Robbins, with contributions from Nima Bigdely-Shamlo, Tim Mullen, Christian Kothe, and Cassidy Matousek.

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

%function eegplugin_clean_rawdata(fig,try_strings,catch_strings)

% create menu
% toolsmenu = findobj(fig, 'tag', 'tools');
% uimenu( toolsmenu, 'label', 'Clean continuous data using ASR', 'separator','on',...
%    'callback', 'EEG = pop_clean_rawdata(EEG); [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG); eeglab redraw');

% eegplugin_prepPipeline() - the PREP pipeline plugin
function vers = eegplugin_prepPipeline(fig, trystrs, catchstrs) 

%% Add path to prepPipeline subdirectories if not in the list
tmp = which('getPrepDefaults');
if isempty(tmp)
    myPath = fileparts(which('prepPipeline'));
    addpath(genpath(myPath));
end;
vers = getPrepVersion(); 

% create menu
comprep = [trystrs.no_check '[EEG LASTCOM] = pop_prepPipeline(EEG);' catchstrs.new_and_hist];
menu = findobj(fig, 'tag', 'tools');
uimenu( menu, 'Label', 'Run PREP pipeline', 'callback', comprep, ...
    'separator', 'on');

