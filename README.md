EEG-Clean-Tools
===============

Contains tools for EEG standardized preprocessing

Version 0.18 Released 10/15/2014

* Refactored so that all input to the pipeline is in a single params structure.
* Fixed the HF noise reporting windows and several minor bugs
* Added visualizations to show number of bad channels in each window

Version 0.19 Released 10/16/2014

* Refactored name is also included in the params structure.
* Renamed rereferencedChannels as channelsToBeReferenced to agree with ESS.

Version 0.20 Released 10/18/2014

* Converted standardLevel2Pipeline to a function
* Moved the computationTimes structure to standardLevel2Pipeline so that
it is returned.

Version 0.21 Released 10/30/2104

* Removed any reference to chanlocs in highPassFilter
* Full integration with ESS Study Level 2 code
* Preliminary version of Standard Level 2 Report finalized (gives pdf)

Version 0.22 Released 11/9/2014

* Revised the method of computing the windowed channel deviations
* Added summary reporting functions
* Added a check to only perform ransac when sufficiently good channels
  are available
* Added check to only perform ransac when channel locations are available
* Fixed the input parameter structure on findNoisyChannels
* Added the infrastructure for the summary of all datasets

Version 0.23 Released 11/13/2014

* Removed the channel locations and channel information from noisyOut
  because it is already in the reference structure at top level.
* Added reporting of average fraction of channels bad in windows.
* Added first version of hdf5support -- rewrites the noisyParameters
  to an HDF5 file.

Version 0.24 Released 12/7/2104 (major)
* Fixed channel selection bug in showSpectrum
* Added error handling for failures in standardLevel2Pipeline
* Added error reporting for failures
* Corrected time scale on visualization of difference between 
  robust and mean reference 
* Added channel labels as well as numbers to spectrum visualization
* Fixed major bug in robustReference so that original signal is rereferenced
* Revised and expanded the reporting

Version 0.25 Not yet released
* Removed saving of temporary file after line noise removal
* Fixed report of relative reference
* Modified findNoisyChannels to exclude NaN and constant channels 
  from noisyChannel thresholding, but to designate them as bad channels
* Moved resampling step before high pass filter
* Assigned return values in a separate step
* Put error check in ShowSpectrum when invalid data is invalid
* Correct minor issues with PlotScalpMap
* Added extractReferenceStatistics -- which extracts summary statistics
  for an entire archive.
* Added iterations on the remove robust reference
* Added a summary reporting scheme for spotting problematic datasets.