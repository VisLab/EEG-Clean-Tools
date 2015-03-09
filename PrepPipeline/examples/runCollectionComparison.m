%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specify collection files, legends and colors for the comparison
statFiles = {
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\VEPPrep\\VEPAverageHP1Hz_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\NCTU\\NCTUStandardLevel2\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\NCTU\SpecificLevel2Average\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\NCTU\SpecificLevel2MastoidBefore\\dataStatistics.mat'
    };

legendString = {'B64-Robust '; 'B64-Average '; 'B64-Mastoid '; ...
                'N32-Robust '; 'N32-Average '; 'N32-Mastoid '
    };
collectionColors =   [0, 0, 0.9; 0, 0, 0; 0, 0.8, 0.2];

%% Consolidate the collection statistics from files 
[collections, collectionStats] = getCollections(statFiles);

%% Compare statistics for different collections using boxplots
showCollectionStatistics(collectionStats, legendString, collectionColors);

%% Calculate the rank significance of all combinations of a statistic.
rankSigRatiosDev = getRankSignificance(collectionStats.refRatiosDev, legendString);
rankSigRatiosWinDev = getRankSignificance(collectionStats.refRatiosWinDev, legendString);
rankSigRatiosWinDevOrig = getRankSignificance(collectionStats.origRatiosWinDev, legendString);
rankSigRatiosHF = getRankSignificance(collectionStats.refRatiosHF, legendString);
rankSigRatiosWinHF = getRankSignificance(collectionStats.refRatiosWinHF, legendString);
rankSigCorr = getRankSignificance(collectionStats.refCorr, legendString);
rankSigDev = getRankSignificance(collectionStats.refDev, legendString);
rankSigWinDev = getRankSignificance(collectionStats.refWinDev, legendString);
rankSigHF = getRankSignificance(collectionStats.refHF, legendString);
rankSigWinHF = getRankSignificance(collectionStats.refWinHF, legendString);
 