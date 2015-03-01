function [report, badFileNames] = getCollectionIssues(collectionStats)
%% Generates issue reports for a collection
     report = sprintf('Issue report for: %s\n', ...
                      collectionStats.collectionTitle);
     badFileNames = {};            
     for k = 1:length(collectionStats.dataTitles)
         dataReport = generateIssueReport(collectionStats, k);
         if isempty(dataReport)
             continue;
         end
         badFileNames{end + 1} = collectionStats.dataTitles{k}; %#ok<AGROW>
         report = [report ...
                  sprintf('\n%s:\n', collectionStats.dataTitles{k}) ...
                  dataReport]; %#ok<AGROW>
     end
end
          