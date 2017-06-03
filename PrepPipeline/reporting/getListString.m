function listString = getListString(list)
% Produce a string with list values
   listString = sprintf('%g ', list(:)');
   listString = ['[ ' listString ']'];
