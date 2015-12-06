EEG-Clean-Tools
===============

Contains tools for the PREP pipeline for standardized preprocessing of EEG. You can
find user documention at: 
   http://vislab.github.io/EEG-Clean-Tools/   
   
**Note:** For convenience, EEGLABPlugin directory contains the latest released version of the
PREP that can be unzipped into your EEGLAB plugins directory.  

### Citing the PREP pipeline
The PREP pipeline is freely available under the GUN General Public License. 
Please cite the following publication if using:  
> Bigdely-Shamlo N, Mullen T, Kothe C, Su K-M and Robbins KA (2015)  
> The PREP pipeline: standardized preprocessing for large-scale EEG analysis  
> Front. Neuroinform. 9:16. doi: 10.3389/fninf.2015.00016  

### People
The PREP pipeline incorporates many algorithms that were developed at
USCS SCCN over many years by Nima Bigdely-Shamlo, Tim Mullen and Christian Kothe.
Kyung Min Su performed most of the machine learning evaluation of PREP. Cassidy
Matousek and Jeremy Cockfield worked on the interfaces for the EEGLAB plugin as
well as associated visualization tools. Kay Robbins of UTSA is the lead developer and
maintainer of PREP.

### Releases   

Version 0.52 Released
* Modified code to handle EEG structures with empty EEG.error.
* Performed additional minor cleanup.

Version 0.51 Not released
* Developing bad window visualization plugin for EEGLAB

Version 0.50 Released
* Made several cleanup modifications to ready for release.

Version 0.48 (Not released -- version 0.47 with EEGLAB integration)
* Integrated EEGLAB plugin
* Changed the default structure value field name from defaults.default to
  default.value and propagated the change
* Changed default names of line noise and global trend to linenoise and 
  globaltrend
* Modified the resampling step to allow an option low pass filter to remove
  downsampling artifacts just below Nyquist frequency.

  Version 0.47 (Not released -- version 0.46 with additional changes)
* Minor refactoring of performReference to avoid 1 extra filtering operation ---
  should not reflect results.
* Also added average and specific referencing methods -- not tested as yet.

Version 0.46 (Not released - version 0.45 with additional changes)
* Fixed remapping of bad evaluation channels into original channel numbers
  (relevant when there are none EEG channels interspersed in the channel
  locations.
* Passed detrend information in reference structure to allow detrending 
  with other than the defaults
* Corrected several channel mapping issues in the reporting.

Version 0.45 (Not released - version 0.44 with additional changes)
* Refactored report to allow statistics to be gathered from noisy structures

Version 0.44 (Not released - version 0.43 with additional changes)
* Corrected a minor issue with reporting -- difference between robust
  and ordinary reference had axes reversed.
* Updated to run with plotting compatible with MATLAB 2014b
* Added box on to cummulative plots.

Version 0.43 (Not released - version 0.42 with additional changes)
* Corrected a minor issue with reporting -- mean scalp correlation map for
  beforeInterpolation was plotting the Original data rather than the
  beforeInterpolation data.

Version 0.42 (Not released - version 0.41 with additional changes)
* Added default line frequencies as multiples of 60 up to half nyquist.

Version 0.41 (Not released - version 0.40 with additional changes)
* Replaced default method with channel forgetting and median initialization
* Converted EEG to double at the beginning of the pipeline
* Added a noisyStatisticsForInterpolation field to the reference reporting
  structure.

Version 0.40 (Not yet released - major change in strategy)
* Changed the name from StandardLevel2 to PrepPipeline
* Implemented the HP filter-free strategy
* Added a keepFiltered version -- if false (the default) the data in the
  repository is not high pass filtered
* Added an option for removing global trend
* Incorporated the different reference schemes into a single performReference

Version 0.28 (Not yet released)
* Changed the name of the noisyParameter structure in EEG.etc to 
  noiseDetection.   This is a major change with corresponding change
  in ESS.
* Added a specificReferenceChannels field to reference structure
* Changed the averageReference field name to referenceSignal in reference
  structure
* Included a referenceType field in the reference structure (this
  can be 'robust', 'average', or 'specific')
* Eliminated the don't interpolateHFChannels flag.
* Added routines to do specificReference (mastoid or average)
* Modified showSpectrum to return the spectra of all of the channels.
* Detrending at 0.2 Hz has replaced FIR filtering as default trend removal.

Version 0.27 Released 1/7/2015
* Correct version of bug fix in cleanLineNoise -- watch that single
  precision conversion!

Version 0.26 Released 1/7/2015
* Release to fix bug in cleanLineNoise --- channels that are not 
  lineNoiseChannels were set to zero rather than being carried forward.

  Version 0.25 Released 1/5/2015 (major)
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

Version 0.24 Released 12/7/2104 (major)
* Fixed channel selection bug in showSpectrum
* Added error handling for failures in standardLevel2Pipeline
* Added error reporting for failures
* Corrected time scale on visualization of difference between 
  robust and mean reference 
* Added channel labels as well as numbers to spectrum visualization
* Fixed major bug in robustReference so that original signal is rereferenced
* Revised and expanded the reporting

Version 0.23 Released 11/13/2014

* Removed the channel locations and channel information from noisyOut
  because it is already in the reference structure at top level.
* Added reporting of average fraction of channels bad in windows.
* Added first version of hdf5support -- rewrites the noisyParameters
  to an HDF5 file.

Version 0.22 Released 11/9/2014

* Revised the method of computing the windowed channel deviations
* Added summary reporting functions
* Added a check to only perform ransac when sufficiently good channels
  are available
* Added check to only perform ransac when channel locations are available
* Fixed the input parameter structure on findNoisyChannels
* Added the infrastructure for the summary of all datasets

Version 0.21 Released 10/30/2104

* Removed any reference to chanlocs in highPassFilter
* Full integration with ESS Study Level 2 code
* Preliminary version of Standard Level 2 Report finalized (gives pdf)

Version 0.20 Released 10/18/2014

* Converted standardLevel2Pipeline to a function
* Moved the computationTimes structure to standardLevel2Pipeline so that
it is returned.

Version 0.19 Released 10/16/2014

* Refactored name is also included in the params structure.
* Renamed rereferencedChannels as channelsToBeReferenced to agree with ESS.

Version 0.18 Released 10/15/2014

* Refactored so that all input to the pipeline is in a single params structure.
* Fixed the HF noise reporting windows and several minor bugs
* Added visualizations to show number of bad channels in each window







