function writeStr(fileId, dataset, value)
% Writes a string dataset to the specified HDF5 file
%
% writeStr(fileId, dataset, value)
%
% Input:
%   fileId            The file id
%   dataset           The path of the dataset
%   value             The value of the dataset
%

fileType = H5T.copy('H5T_FORTRAN_S1');
H5T.set_size(fileType, numel(value));
memType = H5T.copy ('H5T_C_S1');
H5T.set_size (memType, numel(value))
spaceId = H5S.create('H5S_SCALAR');
datasetId = H5D.create(fileId, dataset, fileType, spaceId, 'H5P_DEFAULT');
H5D.write(datasetId, memType, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', value);
H5D.close(datasetId);
H5S.close(spaceId);

end % writeStr

