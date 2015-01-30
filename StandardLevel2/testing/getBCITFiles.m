%% Run the BCIT data and get a list of the set files for checking
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\ARL_BCIT_Program\\STDL1'; % Input data directory used for this demo
outfile = 'E:\\CTAData\\ARL_BCIT_Program\\FileList.txt';
%% Get a list of the files in the driving data from level 1
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);

%% Open the output file
fid = fopen(outfile, 'w');
%% Write out only the set filenames
fCount = 0;
for k = 1:length(in_names)
    ext = in_names{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    fprintf(fid, '%s\n', in_names{k});
    fCount = fCount + 1;
end
fclose(fid);