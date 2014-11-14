function writeCellStr(fileId, dataset, value)
% Writes a cellstr dataset to the specified HDF5 file
%
% writeCellStr(fileId, dataset, value)
%
% Input:
%   fileId            The file id 
%   dataset           The path of the dataset 
%   value             The value of the dataset
%

fileType = H5T.copy('H5T_FORTRAN_S1');
H5T.set_size(fileType, 'H5T_VARIABLE');
memType = H5T.copy('H5T_C_S1');
H5T.set_size(memType, 'H5T_VARIABLE');
dims = size(value);
flippedDims = fliplr(dims);
spaceId = H5S.create_simple(ndims(value),flippedDims, []);
datasetId = H5D.create (fileId, dataset, fileType, spaceId, 'H5P_DEFAULT');
H5D.write(datasetId, memType, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', value);
H5D.close(datasetId);
H5S.close(spaceId);

end % writeCellStr
