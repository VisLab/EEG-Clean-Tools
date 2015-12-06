function [errCode, errMsgs] = compareEEG(EEG1, EEG2, dataFlg)
tol = 1E-10;
errCode = 0;
errMsgs = {};
%% Check data
if size(EEG1.data, 1) ~= size(EEG2.data, 1)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'data channel numbers do not agree';
elseif size(EEG1.data, 2) ~= size(EEG2.data, 2)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'data frame numbers do not agree';
elseif dataFlg && sum(sum(abs(EEG1.data - EEG2.data))) > tol
    errCode = errCode + 1;
    errMsgs{end + 1} = 'data values do not agree';
end

%% Check times
if size(EEG1.times, 1) ~= size(EEG2.times, 1)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'times sizes do not agree';
elseif size(EEG1.times, 2) ~= size(EEG2.times, 2)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'times sizes not agree';
elseif sum(sum(abs(EEG1.times - EEG2.times))) > 0
    errCode = errCode + 1;
    errMsgs{end + 1} = 'times values do not agree';
end

%% Check timestamps
if (isfield(EEG1.etc, 'timestamp'))
    if size(EEG1.etc.timestamp, 1) ~= size(EEG2.etc.timestamp, 1)
        errCode = errCode + 1;
        errMsgs{end + 1} = 'timestamp sizes do not agree';
    elseif size(EEG1.etc.timestamp, 2) ~= size(EEG2.etc.timestamp, 2)
        errCode = errCode + 1;
        errMsgs{end + 1} = 'timestamp sizes not agree';
    elseif sum(sum(abs(EEG1.etc.timestamp - EEG2.etc.timestamp))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'timestamp values do not agree';
    end
end

%% Check events
if length(EEG1.event) ~= length(EEG2.event)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'event sizes do not agree';
else
    if sum(~strcmpi(strtrim({EEG1.event.type}), strtrim({EEG2.event.type}))) > 0
        errCode = errCode + 1;
        errMsgs{end + 1} = 'event type do not agree';
    end 
    if sum(sum(abs(cell2mat({EEG1.event.latency}) - cell2mat({EEG2.event.latency})))) > 0
        errCode = errCode + 1;
        errMsgs{end + 1} = 'event latencies do not agree';
    end 
    if isfield(EEG1.event, 'usertags') && ...
        sum(~strcmpi(strtrim({EEG1.event.usertags}), strtrim({EEG2.event.usertags}))) > 0
           errCode = errCode + 1;
          errMsgs{end + 1} = 'event usertags do not agree';
    end
end
%% check chanlocs
if length(EEG1.chanlocs) ~= length(EEG2.chanlocs)
    errCode = errCode + 1;
    errMsgs{end + 1} = 'chanlocs sizes do not agree';
else
    if sum(~strcmpi(strtrim({EEG1.chanlocs.type}), strtrim({EEG2.chanlocs.type}))) > 0
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs type do not agree';
    end 
    if sum(~strcmpi(strtrim({EEG1.chanlocs.labels}), strtrim({EEG2.chanlocs.labels}))) > 0
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs labels do not agree';
    end 
    if sum(sum(abs(cell2mat({EEG1.chanlocs.X}) - cell2mat({EEG1.chanlocs.X})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs X do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.Y}) - cell2mat({EEG1.chanlocs.Y})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs Y do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.Z}) - cell2mat({EEG1.chanlocs.Z})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs Z do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.theta}) - cell2mat({EEG1.chanlocs.theta})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs theta do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.radius}) - cell2mat({EEG1.chanlocs.radius})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs radius do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.sph_theta}) - cell2mat({EEG1.chanlocs.sph_theta})))) > tol
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs sph_theta do not agree';
    end
    if sum(sum(abs(cell2mat({EEG1.chanlocs.sph_phi}) - cell2mat({EEG1.chanlocs.sph_phi})))) > 0
        errCode = errCode + 1;
        errMsgs{end + 1} = 'chanlocs sph_phi do not agree';
    end
end