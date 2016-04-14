% spectopo() - Plot the mean log spectrum of a set of data epochs at all channels
%              as a bundle of traces. At specified frequencies, plot the relative
%              topographic distribution of power. If available, uses pwelch() from
%              the Matlab signal processing toolbox, else the EEGLAB spec() function.
%              Plots the mean spectrum for all of the supplied data, not just
%              the pre-stimulus baseline.
% Usage:
%              >> spectopo(data, frames, srate);
%              >> [spectra,freqs,speccomp,contrib,specstd] = ...
%                    spectopo(data, frames, srate, 'key1','val1', 'key2','val2' ...);
% Inputs:
%       data   = If 2-D (nchans,time_points); % may be a continuous single epoch,
%                else a set of concatenated data epochs, else a 3-D set of data
%                epochs (nchans,frames,epochs)
%       frames = frames per epoch {default|0 -> data length}
%       srate  = sampling rate per channel (Hz)
%
% Optional 'keyword',[argument] input pairs:
%   'freq'     = [float vector (Hz)] vector of frequencies at which to plot power
%                scalp maps, or else a single frequency at which to plot component
%                contributions at a single channel (see also 'plotchan').
%   'chanlocs' = [electrode locations filename or EEG.chanlocs structure].
%                    For format, see >> topoplot example
%   'limits'   = [xmin xmax ymin ymax cmin cmax] axis limits. Sets x, y, and color
%                axis limits. May omit final values or use NaNs.
%                   Ex: [0 60 NaN NaN -10 10], [0 60], ...
%                Default color limits are symmetric around 0 and are different
%                for each scalp map {default|all NaN's: from the data limits}
%   'freqfac'  = [integer] ntimes to oversample -> frequency resolution {default: 2}
%   'nfft'     = [integer] length to zero-pad data to. Overwrites 'freqfac' above.
%   'winsize'  = [integer] window size in data points {default: from data}
%   'overlap'  = [integer] window overlap in data points {default: 0}
%   'percent'  = [float 0 to 100] percent of the data to sample for computing the
%                spectra. Values < 100 speed up the computation. {default: 100}.
%   'freqrange' = [min max] frequency range to plot. Changes x-axis limits {default:
%                1 Hz for the min and Nyquist (srate/2) for the max. If specified
%                power distribution maps are plotted, the highest mapped frequency
%                determines the max freq}.
%   'reref'    = ['averef'|'off'] convert data to average reference {default: 'off'}
%   'mapnorm'  = [float vector] If 'data' contain the activity of an independant
%                component, this parameter should contain its scalp map. In this case
%                the spectrum amplitude will be scaled to component RMS scalp power.
%                Useful for comparing component strengths {default: none}
%   'boundaries' = data point indices of discontinuities in the signal {default: none}
%   'plot'     = ['on'|'off'] 'off' -> disable plotting {default: 'on'}
%   'rmdc'     = ['on'|'off'] 'on' -> remove DC {default: 'off'}
%   'plotmean' = ['on'|'off'] 'on' -> plot the mean channel spectrum {default: 'off'}
%   'plotchans' = [integer array] plot only specific channels {default: all}
%
% Optionally plot component contributions:
%   'weights'  = ICA unmixing matrix. Here, 'freq' (above) must be a single frequency.
%                ICA maps of the N ('nicamaps') components that account for the most
%                power at the selected frequency ('freq') are plotted along with
%                the spectra of the selected channel ('plotchan') and components
%                ('icacomps').
%   'plotchan' = [integer] channel at which to compute independent conmponent
%                contributions at the selected frequency ('freq'). If 0, plot RMS
%                power at all channels. {defatul|[] -> channel with highest power
%                at specified 'freq' (above)). Do not confuse with
%                'plotchans' which select channels for plotting.
%   'mapchans' = [int vector] channels to plot in topoplots {default: all}
%   'mapframes'= [int vector] frames to plot {default: all}
%   'nicamaps' = [integer] number of ICA component maps to plot {default: 4}.
%   'icacomps' = [integer array] indices of ICA component spectra to plot ([] -> all).
%   'icamode'  = ['normal'|'sub'] in 'sub' mode, instead of computing the spectra of
%                individual ICA components, the function computes the spectrum of
%                the data minus their contributions {default: 'normal'}
%   'icamaps'  = [integer array] force plotting of selected ICA compoment maps
%                {default: [] = the 'nicamaps' largest contributing components}.
%   'icawinv'  = [float array] inverse component weight or mixing matrix. Normally,
%                this is computed by inverting the ICA unmixing matrix 'weights' (above).
%                However, if any components were removed from the supplied 'weights'mapchans
%                then the component maps will not be correctly drawn and the 'icawinv'
%                matrix should be supplied here {default: from component 'weights'}
%   'memory'   = ['low'|'high'] a 'low' setting will use less memory for computing
%                component activities, will take longer {default: 'high'}
%
% Replotting options:
%   'specdata' = [freq x chan array ] spectral data
%   'freqdata' = [freq] array of frequencies
%
% Topoplot options:
%    other 'key','val' options are propagated to topoplot() for map display
%                (See >> help topoplot)
%
% Outputs:
%        spectra  = (nchans,nfreqs) power spectra (mean power over epochs), in dB
%        freqs    = frequencies of spectra (Hz)
%
% Notes: The original input format is still functional for backward compatibility.
%        psd() has been replaced by pwelch() (see Matlab note 24750 on their web site)
%
% Authors: Scott Makeig, Arnaud Delorme & Marissa Westerfield,
%          SCCN/INC/UCSD, La Jolla, 3/01
%
% See also: timtopo(), envtopo(), tftopo(), topoplot()

% Copyright (C) 3/01 Scott Makeig & Arnaud Delorme & Marissa Westerfield, SCCN/INC/UCSD,
% scott@sccn.ucsd.edu
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

% 3-20-01 added limits arg -sm
% 01-25-02 reformated help & license -ad
% 02-15-02 scaling by epoch number line 108 - ad, sm & lf
% 03-15-02 add all topoplot options -ad
% 03-18-02 downsampling factor to speed up computation -ad
% 03-27-02 downsampling factor exact calculation -ad
% 04-03-02 added axcopy -sm

% Uses: MATLAB pwelch(), changeunits(), topoplot(), textsc()

function [eegspecdB,freqs] = calculateSpectrum(data,frames,srate,varargin)

% formerly: ... headfreqs,chanlocs,limits,titl,freqfac, percent, varargin)

FREQFAC  = 2;

if nargin<3
    help spectopo
    return
end
if nargin <= 3 || ischar(varargin{1})
    % 'key' 'val' sequence
    fieldlist = { 'freq'          'real'     []                        [] ;
        'specdata'      'real'     []                        [] ;
        'freqdata'      'real'     []                        [] ;
        'chanlocs'      ''         []                        [] ;
        'freqrange'     'real'     [0 srate/2]               [] ;
        'memory'        'string'   {'low','high'}           'high' ;
        'plotmean'      'string'   {'on','off'}             'off' ;
        'limits'        'real'     []                       [nan nan nan nan nan nan];
        'freqfac'       'integer'  []                        FREQFAC;
        'percent'       'real'     [0 100]                  100 ;
        'reref'         'string'   { 'averef','off','no' }  'off' ;
        'boundaries'    'integer'  []                       [] ;
        'nfft'          'integer'  [1 Inf]                  [] ;
        'winsize'       'integer'  [1 Inf]                  [] ;
        'overlap'       'integer'  [1 Inf]                  0 ;
        'icamode'       'string'   { 'normal','sub' }        'normal' ;
        'weights'       'real'     []                       [] ;
        'mapnorm'       'real'     []                       [] ;
        'plotchan'      'integer'  1:size(data,1)         [] ;
        'plotchans'     'integer'  1:size(data,1)         [] ;
        'nicamaps'      'integer'  []                       4 ;
        'icawinv'       'real'     []                       [] ;
        'icacomps'      'integer'  []                       [] ;
        'icachansind'   'integer'  []                       1:size(data,1) ; % deprecated
        'icamaps'       'integer'  []                       [] ;
        'rmdc'           'string'   {'on','off'}          'off';
        'mapchans'      'integer'  1:size(data,1)         []
        'mapframes'     'integer'  1:size(data,2)         []};
    
    [g, varargin] = finputcheck(varargin, fieldlist, 'spectopo', 'ignore');
    if ischar(g), error(g); end;
    if ~isempty(g.freqrange), g.limits(1:2) = g.freqrange; end;
    if ~isempty(g.weights)
        if isempty(g.freq) || length(g.freq) > 2
            if ~isempty(get(0,'currentfigure')) && strcmp(get(gcf, 'tag'), 'spectopo'), close(gcf); end;
            error('spectopo(): for computing component contribution, one must specify a (single) frequency');
        end;
    end;
else
    if ~isnumeric(data)
        error('spectopo(): Incorrect call format (see >> help spectopo).')
    end
    if ~isnumeric(frames) || round(frames) ~= frames
        error('spectopo(): Incorrect call format (see >> help spectopo).')
    end
    if ~isnumeric(srate)  % 3rd arg must be the sampling rate in Hz
        error('spectopo(): Incorrect call format (see >> help spectopo).')
    end
    
    if nargin > 3,    g.freq = varargin{1};
    else              g.freq = [];
    end;
    if nargin > 4,	  g.chanlocs = varargin{2};
    else              g.chanlocs = [];
    end;
    if nargin > 5,    g.limits = varargin{3};
    else              g.limits = [nan nan nan nan nan nan];
    end;
    if nargin > 6,    g.freqfac = varargin{4};
    else              g.freqfac = FREQFAC;
    end;
    if nargin > 7,    g.percent = varargin{5};
    else              g.percent = 100;
    end;
    if nargin > 9,    g.reref = 'averef';
    else               g.reref = 'off';
    end;
    g.weights = [];
    g.icamaps = [];
end;
if g.percent > 1
    g.percent = g.percent/100; % make it from 0 to 1
end;
if ~isempty(g.freq) && isempty(g.chanlocs)
    error('spectopo(): needs channel location information');
end;
if isempty(g.weights) && ~isempty(g.plotchans)
    data = data(g.plotchans,:);
    if ~isempty(g.chanlocs)
        g.chanlocs = g.chanlocs(g.plotchans);
    end;
end;

if strcmpi(g.rmdc, 'on')
    data = data - repmat(mean(data,2), [ 1 size(data,2) 1]);
end
data = reshape(data, size(data,1), size(data,2)*size(data,3));

if frames == 0
    frames = size(data,2); % assume one epoch
end

if ~isempty(g.freq) && min(g.freq)<0
    if ~isempty(get(0,'currentfigure')) && strcmp(get(gcf, 'tag'), 'spectopo'), close(gcf); end;
    return
end

g.chanlocs2 = g.chanlocs;
if ~isempty(g.specdata)
    eegspecdB  = g.specdata;
    freqs      = g.freqdata;
else
    epochs = round(size(data,2)/frames);
    if frames*epochs ~= size(data,2)
        error('Spectopo: non-integer number of epochs');
    end
    if ~isempty(g.weights)
        if isempty(g.icawinv)
            g.icawinv = pinv(g.weights); % maps
        end;
        if ~isempty(g.icacomps)
            g.weights = g.weights(g.icacomps, :);
            g.icawinv = g.icawinv(:,g.icacomps);
        else
            g.icacomps = 1:size(g.weights,1);
        end;
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute channel spectra using pwelch()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    epoch_subset = ones(1,epochs);
    if g.percent ~= 1 && epochs == 1
        frames = round(size(data,2)*g.percent);
        data = data(:, 1:frames);
        g.boundaries(g.boundaries > frames) = [];
        if ~isempty(g.boundaries)
            g.boundaries(end+1) = frames;
        end;
    end;
    if g.percent ~= 1 && epochs > 1
        epoch_subset = zeros(1,epochs);
        nb = ceil( g.percent*epochs);
        while nb>0
            index = ceil(rand*epochs);
            if ~epoch_subset(index)
                epoch_subset(index) = 1;
                nb = nb-1;
            end;
        end;
        epoch_subset = find(epoch_subset == 1);
    else
        epoch_subset = find(epoch_subset == 1);
    end;
    if isempty(g.weights)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % compute data spectra
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        [eegspecdB, freqs] = spectcomp( data, frames, srate, epoch_subset, g);
        if ~isempty(g.mapnorm) % normalize by component map RMS power (if data contain 1 component
            %disp('Scaling spectrum by component RMS of scalp map power');
            eegspecdB       = sqrt(mean(g.mapnorm.^4)) * eegspecdB;
            % the idea is to take the RMS of the component activity (compact) projected at each channel
            % spec = sqrt( power(g.mapnorm(1)*compact).^2 + power(g.mapnorm(2)*compact).^2 + ...)
            % spec = sqrt( g.mapnorm(1)^4*power(compact).^2 + g.mapnorm(1)^4*power(compact).^2 + ...)
            % spec = sqrt( g.mapnorm(1)^4 + g.mapnorm(1)^4 + ... )*power(compact)
        end;
        
        tmpc = find(eegspecdB(:,1)); 			     % > 0 power chans
        if length(tmpc) ~= size(eegspecdB,1)
            eegspecdB = eegspecdB(tmpc,:);
            if ~isempty(g.chanlocs)
                g.chanlocs2 = g.chanlocs(tmpc);
            end
        end;
        eegspecdB = 10*log10(eegspecdB);
    else
        % compute data spectrum
        if isempty(g.plotchan) || g.plotchan == 0
            [eegspecdB, freqs] = spectcomp( data, frames, srate, epoch_subset, g);
        else
            g.reref = 'off';
            [eegspecdB, freqs] = spectcomp( data(g.plotchan,:), frames, srate, epoch_subset, g);
        end;
        g.reref = 'off';
        
        tmpc = find(eegspecdB(:,1)); 			% > 0 power chans
        if length(tmpc) ~= size(eegspecdB,1)
            eegspecdB = eegspecdB(tmpc,:);
            if ~isempty(g.chanlocs)
                g.chanlocs2 = g.chanlocs(tmpc);
            end
        end;
        eegspecdB = 10*log10(eegspecdB);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % compute component spectra
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        newweights = g.weights;
        if strcmp(g.memory, 'high') && strcmp(g.icamode, 'normal')
            [~, freqs] = spectcomp( newweights*data(:,:), frames, srate, epoch_subset, g);
        else % in case out of memory error, multiply conmponent sequencially
            if strcmp(g.icamode, 'sub') && ~isempty(g.plotchan) && g.plotchan == 0
                % scan all electrodes
                for index = 1:size(data,1)
                    g.plotchan = index;
                    [~, freqs] = spectcomp( data, frames, srate, epoch_subset, g, newweights);
                end;
                g.plotchan = 0;
            else
                [~, freqs] = spectcomp( data, frames, srate, epoch_subset, g, newweights);
            end;
        end;
    end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function computing spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [eegspecdB, freqs] = spectcomp( data, frames, srate, epoch_subset, g, newweights)
if exist('newweights', 'var') == 1
    nchans = size(newweights,1);
else
    nchans = size(data,1);
end;
%fftlength = 2^round(log(srate)/log(2))*g.freqfac;
if isempty(g.winsize)
    winlength = max(pow2(nextpow2(frames)-3),4); %*2 since diveded by 2 later
    winlength = min(winlength, 512);
    winlength = max(winlength, 256);
    winlength = min(winlength, frames);
else
    winlength = g.winsize;
end;
winlength = round(winlength);  % Added round off for integer windows
if isempty(g.nfft)
    fftlength = 2^(nextpow2(winlength))*g.freqfac;
else
    fftlength = g.nfft;
end;
%     usepwelch = 1;
usepwelch = license('checkout','Signal_Toolbox'); % 5/22/2014 Ramon
%     if ~license('checkout','Signal_Toolbox'),
% if ~usepwelch,
% end;

for c=1:nchans % scan channels or components
    if exist('newweights', 'var') == 1
        if strcmp(g.icamode, 'normal')
            tmpdata = newweights(c,:)*data; % component activity
        else % data - component contribution
            tmpdata = data(g.plotchan,:) - (g.icawinv(g.plotchan,c)*newweights(c,:))*data;
        end;
    else
        tmpdata = data(c,:); % channel activity
    end;
    if strcmp(g.reref, 'averef')
        tmpdata = averef(tmpdata);
    end;
    for e=epoch_subset
        if isempty(g.boundaries)
            theData = matsel(tmpdata,frames,0,1,e);
            if usepwelch
                [tmpspec,freqs] = pwelch(theData,...
                    winlength,g.overlap,fftlength,srate);
            else
                [tmpspec,freqs] = spec(theData,fftlength,srate,...
                    winlength,g.overlap);
            end;
            %[tmpspec,freqs] = psd(matsel(tmpdata,frames,0,1,e),fftlength,srate,...
            %					  winlength,g.overlap);
            if c==1 && e==epoch_subset(1)
                eegspec = zeros(nchans,length(freqs));
            end
            eegspec(c,:) = eegspec(c,:) + tmpspec';
        else
            g.boundaries = round(g.boundaries);
            for n=1:length(g.boundaries)-1
                if g.boundaries(n+1) - g.boundaries(n) >= winlength % ignore segments of less than winlength
                    if usepwelch
                        [tmpspec,freqs] =  pwelch(tmpdata(e,g.boundaries(n)+1:g.boundaries(n+1)),...
                            winlength,g.overlap,fftlength,srate);
                    else
                        [tmpspec,freqs] =  spec(tmpdata(e,g.boundaries(n)+1:g.boundaries(n+1)),...
                            fftlength,srate,winlength,g.overlap);
                    end;
                    if exist('eegspec', 'var') ~= 1
                        eegspec = zeros(nchans,length(freqs));
                    end
                    eegspec(c,:) = eegspec(c,:) + tmpspec'* ...
                        ((g.boundaries(n+1)-g.boundaries(n)+1)/g.boundaries(end));
                end;
            end
        end;
    end
end

n = length(epoch_subset);
eegspecdB = eegspec/n; % normalize by the number of sections
return;
