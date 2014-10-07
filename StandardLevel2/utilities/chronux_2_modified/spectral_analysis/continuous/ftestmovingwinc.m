function [Fval sig f A t] = ftestmovingwinc(data,movingwin,params,p,plt)
% compute Thompson f-statistic for each segment within a sliding window
% Fval is a [num_window x num_freqs] matrix of f-values
% sig is the f-value threshold corresponding to the desired significance level of p

if nargin<5
    plt = 'n';
end

% data is [trials/channels x time]

data=change_row_to_column(data);
[N C] = size(data);  % make data [time x trials/chans]

[tapers,pad,Fs,fpass,err,trialave,params]=getparams(params);


Nwin=round(Fs*movingwin(1));    % number of samples in window
Nstep=round(movingwin(2)*Fs);   % number of samples to step through
Noverlap=Nwin-Nstep;            % number of points in overlap
winstart=1:Nstep:N-Nwin+1;
nw=length(winstart);

nfft=max(2^(nextpow2(Nwin)+pad),Nwin);
f=getfgrid(Fs,nfft,fpass);      % frequency grid to be returned

% initalize vars
[Fval] = zeros(nw,length(f));
A = Fval;

for n=1:nw;
    indx=winstart(n):winstart(n)+Nwin-1;
    
    datawin = data(indx,:);
    
    if ~isempty(params.detrend)
       datawin = detrend(datawin,params.detrend);
    end
    
    [Fval(n,:),A(n,:),dummy2,sig] = ftestc(datawin,params,p,plt);
    
%     figure; plot(f,Fval(n,:)); hold on; plot(get(gca,'xlim'),[sig sig],'r'); hold off;
    
end

winmid=winstart+round(Nwin/2);
t=winmid/Fs;