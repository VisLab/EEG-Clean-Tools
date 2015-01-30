%% Check for missing BCIT files
fileName1 = 'E:\\CTAData\\ARL_BCIT_Program\\FileList_T1.txt';
fileName2 = 'E:\\CTAData\\ARL_BCIT_Program\\FileList_T2.txt';
fileName3 = 'E:\\CTAData\\ARL_BCIT_Program\\FileList_T3.txt';
%% Read the lists
fid = fopen(fileName1, 'r');
fileList1 = textscan(fid, '%s');
fclose(fid);
fid = fopen(fileName2, 'r');
fileList2 = textscan(fid, '%s');
fclose(fid);
fid = fopen(fileName3, 'r');
fileList3 = textscan(fid, '%s');
fclose(fid);
%% Check for missing mastoid
outdir = 'N:\\ARL_BCIT_Program\\Level2MastoidReference';
[missing1, present1] = ...
    checkForMissingFiles([outdir filesep 'T1'], fileList1{1});
[missing2, present2] = ...
    checkForMissingFiles([outdir filesep 'T2'], fileList2{1});
[missing3, present3]  = ...
    checkForMissingFiles([outdir filesep 'T3'], fileList3{1});

