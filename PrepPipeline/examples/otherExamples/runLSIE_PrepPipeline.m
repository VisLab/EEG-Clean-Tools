%% Example using ESS
ess1Path = 'O:\ARL_Data\ESS_container_folder_UM_LSIE_07_Indoor';
ess1File = 'O:\ARL_Data\ESS_container_folder_UM_LSIE_07_Indoor\study_description.xml';
ess2Dir = 'O:\ARL_Data\UM_LSIE_07_Indoor';

%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
