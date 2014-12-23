
%%
data1 = 'N:\\ARLAnalysis\\NCTU\\Level2C\\dataStatistics.mat';
load(data1);
ordl2stats = stdl2stats;

%%
data2 = 'N:\\ARLAnalysis\\NCTU\\Level2B\\dataStatistics.mat';
load(data2);

%%
showReferenceStatistics(ordl2stats);

%%
showReferenceStatistics(stdl2stats);

%%
showReferencePairedStatistics(ordl2stats,stdl2stats);