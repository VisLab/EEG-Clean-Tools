function listString = getListString(list)
% Produce a string with list values with a specified number of values per line
   listString = sprintf('%g ', list(:)');
   listString = ['[ ' listString ']'];
