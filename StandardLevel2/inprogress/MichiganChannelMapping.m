%% Read the channel locations
indir = 'E:\\CTAData\\Michigan_ESS_container_folder';
fname = 'channel_locations_UM-LSIE_Visual_Search_Object_Recognition_Task_session_1_subject_1_task_walking_outdoors_LSIE_05_outdoor_recording_1.sfp';
chanlocs = readlocs([indir filesep 'session' filesep '1' filesep fname]);

%% Extract the field names
fields = fieldnames(chanlocs);
%% 
for k = 4:259
    chanlocs(k).type = 'EEG';
end

m = 9;
for k = 268:271
    chanlocs(k).labels = ['EXT' num2str(m)];
    m = m+1;
    for j = 2:length(fields)
        chanlocs(k).(fields{j}) = NaN;
    end
    chanlocs(k).type = 'EXT';
end

%%
for k = 260:271
    chanlocs(k).type = 'EXT';
end

%% Save the channel locations:
save([indir filesep 'chanlocs.mat'], 'chanlocs', '-v7.3')
