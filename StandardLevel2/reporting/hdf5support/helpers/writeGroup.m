function writeGroup(fileId, group)
% Writes a group to the specified HDF5 file
%
% writeGroup(fileId, group)
%
% Input:
%   fileId            The file id 
%   group             The path of the group 
%

groupId = H5G.create(fileId, group, 'H5P_DEFAULT', 'H5P_DEFAULT', ...
    'H5P_DEFAULT');
H5G.close(groupId);

end % writeGroup

