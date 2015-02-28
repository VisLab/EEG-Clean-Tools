function [collectionSummary, issueReport, badFileNames] = getCollectionSummary(collectionStats)
     collectionSummary.collectionTitle = collectionStats.collectionTitle;
         
     issueReport = sprintf('Issue report for: %s\n', ...
                      collectionStats.collectionTitle);
     badFileNames = {};            
     for k = 1:length(collectionStats.dataTitles)
         dataReport = generateIssueReport(collectionStats, k);
         if isempty(dataReport)
             continue;
         end
         badFileNames{end + 1} = collectionStats.dataTitles{k};
         issueReport = [issueReport ...
                  sprintf('\n%s:\n', collectionStats.dataTitles{k}) ...
                  dataReport]; %#ok<AGROW>
     end
     
     %% Summary statistics  
     iterations = cell2mat{collectionStats.noisyChannels.actualInterpolationIterations};
     
end
          