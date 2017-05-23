function writeSummaryHeader(sumFile, summaryHeader, headerFormat) 
%% Write a summary header in HTML at a given <h> level
   if nargin == 2
      fprintf(sumFile, '\n<h2>%s</h2>', summaryHeader);
   else
      fprintf(sumFile, '\n<%s>%s</%s>', ...
          headerFormat, summaryHeader, headerFormat);
   end
end
