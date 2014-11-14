function writeHdf5Structure(file, root, structure)
% Creates a HDF5 file and writes the contents of a structure to it
%
% writeHdf5Structure(file, root, structure)
%
% Input:
%   file            The name of the file
%   root            The name of the structure
%   structure       The structure containing the data
%

fileId = H5F.create(file, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
writeGroup(fileId, ['/', strrep(root, '/', '')]);
addDataset(fileId, ['/', strrep(root, '/', '')], structure);
H5F.close(fileId);

    function addDataset(fileId, path, structure)
        % Writes the structure fields to the file under the specified path
        fieldNames = fieldnames(structure);
        for a = 1:length(fieldNames)
            switch class(structure.(fieldNames{a}))
                case 'cellstr'
                    writeCellStr(fileId, [path, '/', fieldNames{a}], ...
                        {structure.(fieldNames{a})})
                case 'char'
                    if isempty(structure.(fieldNames{a}))
                        writeEmptyStr(fileId, [path, '/', ...
                            fieldNames{a}], ...
                            structure.(fieldNames{a}));
                    else
                        writeStr(fileId, [path, '/', fieldNames{a}], ...
                            structure.(fieldNames{a}));
                    end
                case 'double'
                    if isempty(structure.(fieldNames{a}))
                        writeEmptyDouble(fileId, [path, '/', ...
                            fieldNames{a}], ...
                            structure.(fieldNames{a}))
                    else
                        writeDouble(fileId, ...
                            [path, '/', fieldNames{a}], ...
                            structure.(fieldNames{a}));
                    end
                case 'single'
                    if isempty(structure.(fieldNames{a}))
                        writeEmptySingle(fileId, [path, '/', ...
                            fieldNames{a}], ...
                            structure.(fieldNames{a}))
                    else
                        writeSingle(fileId, ...
                            [path, '/', fieldNames{a}], ...
                            structure.(fieldNames{a}));
                    end
                case 'struct'
                    writeGroup(fileId, [path, '/', fieldNames{a}]);
                    if length(structure.(fieldNames{a})) == 1
                        addDataset(fileId, [path, '/', fieldNames{a}], ...
                            structure.(fieldNames{a}));
                    else
                        addStructureArray(fileId, [path, '/', ...
                            fieldNames{a}], structure.(fieldNames{a}));
                    end
            end
        end
    end % addDataset

    function addStructureArray(fileId, path, structure)
        % Writes the structure array field values to the file under the
        % specified path
        fieldNames = fieldnames(structure);
        for a = 1:length(fieldNames)
            switch class(structure(1).(fieldNames{a}))
                case 'char'
                    writeCellStr(fileId, [path, '/', fieldNames{a}], ...
                        {structure.(fieldNames{a})})
                case 'double'
                    writeDoubleCellArray(fileId, [path, '/', ...
                        fieldNames{a}], {structure.(fieldNames{a})})
                case 'single'
                    writeSingleCellArray(fileId, [path, '/', ...
                        fieldNames{a}], {structure.(fieldNames{a})})
            end
        end
    end % addStructureArray

end % writeHDF5Parameters

