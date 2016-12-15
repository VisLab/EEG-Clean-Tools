# Introduction to the PREP pipeline
The PREP pipeline is a standardized early-stage EEG processing pipeline that focuses on the identification of bad channels and the calculation of a robust average reference. PREP also has an extensive reporting facility. It is designed to be run in a completely automated way. The major sections of this document are:
* Introduction (requirements, citing, installation)
* Algorithm (steps, meaning of parameters for each step)
* Running as an EEGLAB plug-in
* Running as a script

### Requirements
The PREP pipeline relies on the MATLAB Signal Processing toolbox and EEGLAB, a freely-available MATLAB toolbox for processing EEG. EEGLAB is available from  [http://scn.ucsd.edu/eeglab](http://scn.ucsd.edu/eeglab). PREP assumes that the EEG data is provided as an EEGLAB EEG structure and that channel locations are provided in the EEG.chanlocs structure.

### Citing the PREP pipeline
The PREP pipeline is freely available under the GUN General Public License. 
Please cite the following publication if using:  
> Bigdely-Shamlo N, Mullen T, Kothe C, Su K-M and Robbins KA (2015)  
> The PREP pipeline: standardized preprocessing for large-scale EEG analysis  
> Front. Neuroinform. 9:16. doi: 10.3389/fninf.2015.00016  

### Installation
The PREP pipeline can be run in two ways --- as a standalone toolbox or as an EEGLAB plugin. To run in standalone mode, simply download the PREP code, found the the EEG-Clean-Tools

# PREP as an EEGLAB plugin
You can install PREP as an EEGLAB plugin by unzipping the PREPPipeline directory into the plugins directory of
your EEGLAB installation. 

# Using parallel processing with PREP
The PREP pipeline can execute fairly slowly on headsets with a lot of channels. However, many of the steps are embarassingly parallel --- that is the PREP can perform operations separately on individual channels or individual windows.
If you have the MATLAB Parallel Processing Toolbox, you just need to make sure that it is enabled. The following screenshot
of the MATLAB IDE shows the Parallel Processing Toolbox icon on the lower left of the status bar at the very bottom of the window.  
![MATLAB IDE](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/MATLABWorkspace.png)  

To configure your parallel processing toolbox, you should start the worker pool or set MATLAB to automatically start
the pool when needed:  
![MATLAB Parallel processing](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/ParallelProcessing.png)  

## Running the PREP pipeline from EEGLAB
Load an EEG dataset to be processed using the Load dataset submenu under the File menu of EEGLAB.  The PREP pipeline 
can be found under the EEGLAB Tools submenu:  
![PREP from EEGLAB](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepFromEEGLAB.png)  

**[MAIN MENU]** The PREP main menu shows the processing steps:   
![PREP main menu for EEGLAB plugin](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepMainMenu.png)  
Each button allows you to override the default parameters. When you press
the Ok button (or unfortunately the Cancel button), PREP runs.  Use the x button on the upper right to quit without
running the pipeline.  

**[BOUNDARY MENU]** Normally, PREP won't run on data sets that contain Boundary events. The PREP boundary menu allows you to change how PREP handles boundary events:  
![PREP boundary menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepBoundary.png)  
EEGLAB inserts Boundary events to mark discontinuities in the data from epoch rejection or when the data is imported. 
Some, but not all, EEGLAB functions respect discontinuities. PREP expects the data set to be continuous. You should not
override this default setting unless the Boundary events in your data set do not mark discontinuous recording, but 
other features.  

**[DETREND MENU]** PREP must detrend or high pass filter the data prior detecting line noise or referencing in order to properly calibrate the thresholds:  
![PREP detrend menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepDetrend.png)  
By default, PREP uses a high pass filter at 1 Hz for this purpose and does not retain the filtered version of the final
output. This allows you to defer the decision of filtering strategy to downstream processing. Normally, the only default you might need to over ride is what channels to filter. By default, PREP filters all of the channels.  

**[LINE NOISE MENU]** PREP tries to remove sharp spectral peaks representing line noise at this step:  
![PREP line noise menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepLineNoiseParameters.png)  
By default, PREP tries to remove multiples of 60 Hz up to the Nyquist frequency (half of the sampling frequency).
You may need to override this if your data set has unusual spectral features. You might also need to specify
which channels should have line noise removed. By default, PREP tries to remove line noise from all channels.  

**[REFERENCE MENU]** The PREP settings for the actual reference step are:  
![PREP reference menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepReferenceParameters.png)  
Normally, the only things you will need to override are the channel specifications. Usually, the reference channels and 
the evaluation channels correspond to brain EEG channels. The re-referenced channels may include additional channels
such as EOG channels and mastoids.  

**[REPORT MENU]** You can choose to generate a report using the PREP report generation facility:  
![PREP report menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepReportParameters.png)  
By default, the PREP does not produce a report. If you generate choose to generate a report, you can choose to
publish it in PDF format. Otherwise, PREP displays the report on the command line. You can also choose to
return at a later step and generate the report only.  

**[POSTPROCESS MENU]** After running the PREP pipeline, you can perform additional processing steps:  
![PREP post process menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepPostProcess.png)  

**[SAVE MENU]** After PREP completes processing, reporting, and post processing, you are given the option of saving
the processed EEG data set:  
![PREP final save menu](https://raw.githubusercontent.com/VisLab/EEG-Clean-Tools/gh-pages/images/PrepFinalSave.png)  

# PREP Overview
This section discusses the algorithm and the meeting of the various parameters.

### Processing steps
1. Handle boundary events prior to processing
1. Remove trend (high pass) temporarily to properly compute thresholds
1. Remove line noise without committing to a filtering strategy
1. Robustly reference the signal relative to an estimate of the “true” average reference
1. Detect and interpolate bad channels relative to this reference
1. Produce reports if desired
1. Post process if desired

## Boundary marker handling
PREP is meant to work on data obtained from a continuous recording session. However, sometimes researchers record multiple sessions in the same file (such as by temporarily suspending and resuming recording). EEGLAB uses boundary events to mark
these discontinuities. Some (but not all) EEGLAB functions respect these boundary markers. By default, the PREP pipeline will not process data sets with boundary markers. Because some researchers use these boundary markers for other purposes than for marking discontinuities, PREP allows the option of temporarily removing boundary markers before processing and then reinserting afterwards. **You should not disregard boundary markers unless you are absolutely sure that these markers**
**to not represent discontinuities.**

## Detrend (high pass filtering)
High pass filtering of some sort is needed in order for many of the algorithms, including line noise removal and
referencing to perform correctly. However, the exact cutoff may dramatically effect downstream algorithms. By default, 
PREP uses a 1 Hz cutoff, but only temporarily filters, so that the final signal is not high-pass filtered. This
allows you to defer the final choice of high pass cutoff for downstream processing to later. 

### Calling sequence for removing trends
The `removeTrend` function takes two structures in and produces two output structures. The `signal` structure
includes a `.data` field and an `.srate` field. The `signal` structure is compatible with an EEGLAB EEG structure, but does not rely on any of the other EEGLAB fields. The `.data` field should be channels x frames. 

As with all functions in the pipeline, the algorithm parameters are passed in a structure:  
> `[signal, detrendOut] = removeTrend(signal)`  
> `[signal, detrendOut] = removeTrend(signal, detrendIn)`  

The output structure contains all of the input structure fields plus additional fields including a string representation
of the actual command used. Usually, the only field that a user might need to provide is `detrendChannels` if the `signal` structure contains extra channels that represent items other than EEG signals. 

**Example:**  
> `detrendIn = struct('detrendChannels', [1:32, 40:60], 'detrendCutoff', 0.5);`  

### Parameters for removing the trend
The following parameters appear as fields in the `detrendIn` structure:  

**`detrendChannels`**  
 A row vector specifying the channel numbers of the channels to remove the trend from.  
By default, PREP uses all of the channels (`1:size(signal.data, 1)`). 
If your signal has extraneous or unused channels, you should specify which channels to use.  

**`detrendType`**  
The type of detrending operation to perform. At this time the options are `'high pass'`, `'high pass sinc'`, `'linear'`, and
`'none'`. By default, PREP uses `'high pass'` by calling `pop_eegfiltnew` with the default settings. The
`'high pass sinc'` setting calls `pop_firws` with a Blackman window type. The `'linear'` filter is adapted
from the Chronux toolbox and uses local linear regression. The window size is `1.5/detrendCutoff`. Generally,
the `'linear'` option is much slower than simple high pass filtering and gives very similar results.
Usually you don't have to specify this parameter.  

**`detrendCutoff`**  
The cutoff frequency in Hz for high pass filtering or local detrending. By default, PREP uses 1 Hz. Usually you don't have to specify this parameter.

**`detrendStepSize`**  
The amount in seconds to slide the local detrending window when local linear regression is used for detrending. 
By default, PREP uses 0.02 seconds. This parameter is not used unless the `detrendType` is `'linear'`.  

## Line noise removal
We use an iterative version of a method that estimates the amplitude and size of a deterministic sinusoid at a specified frequency embedded in locally white noise. The model is applied in sliding windows to adjust for non stationarity. The algorithm requires a rough guess of the frequencies to be removed. By default, PREP uses multiples of 60 Hz. If the data set was recorded in a place where 50 Hz alternating current is used, you will need to provide the `lineFrequencies` parameter. Sometimes unusual frequencies appear due to aliasing and other recording artifacts. For example, a frequency spike at 212 Hz might appear as an aliasing artifact in a signal recorded at 512 Hz (212 = 512 - 300). You might need to rerun with different frequencies if unusual spectral peaks are visible in the reports. 

### Calling sequence for line noise removal
The `cleanLineNoise` function takes two structures in and produces two output structures. The `signal` structure
includes a `.data` field and an `.srate` field. The `signal` structure is compatible with an EEGLAB EEG structure, but does not rely on any of the other EEGLAB fields. The data field should be channels x frames. 

As with all functions in the pipeline, the algorithm parameters are passed in a structure.  
> `[signal, lineNoiseOut] = cleanLineNoise(signal)`  
> `[signal, lineNoiseOut] = cleanLineNoise(signal, lineNoiseIn)`  

The output structure contains all of the input structure fields plus additional fields containing information on the
tapers used to compute the spectral components and additional fields including a string representation
of the actual command used.

**Example:**  
> `lineNoiseIn = struct('lineNoiseChannels', [1:32, 40:60], 'lineFrequencies', [60, 120, 180, 212, 240]);`  


### Parameters for line noise removal
The following parameters appear as fields in the `lineNoiseIn` structure:  

**`lineNoiseChannels`**  
 A row vector specifying the channel numbers of the channels to remove line noise from.  By default, PREP uses all of the channels (`1:size(signal.data, 1)`). If your signal has extraneous or unused channels, you should specify which channels to use.

**`Fs`**  
The sampling frequency of the signal in Hz. By default, PREP uses the sampling rate specified in `signal.srate`. Usually you don't have to specify this parameter.  

**`lineFrequencies`**  
A vector of frequencies in Hz of the approximate locations of the line noise peaks to remove. By default, PREP removes multiples of 60 Hz up to the Nyquist frequency (which is half of the sampling frequency). After looking at the spectrum in the report, you may need to redo PREP with additional frequencies. If the data was recorded in a location using a 50 Hz power, you will also need to override.  

The clean line noise procedure used in PREP can only remove sharp peaks with minimal spectral distortion. It does not remove broad peaks. If the PREP reports show that line noise has not been removed to a sufficient extent, you may have to perform additional filtering for a particular application.  

**`p`**   
A significance cutoff level for removing a spectral peak. By default, PREP uses a p-value of 0.01. The clean line noise
procedure applies an F-test to determine whether a particular spectral peak is significantly higher than the background level in a small window. You should not have to override this parameter.  

**`fScanBandWidth`**    
Half of the width of the frequency band centered on each line frequency. This band is used to search
for the exact value of the maximum amplitude frequency peak near the specified frequencies to be removed. 
By default, PREP uses 2 Hz. You should not have to override this parameter.  

**`taperBandWidth`**  
Bandwidth in Hz for the Sleppian tapers used to estimate the spectrum. By default, PREP uses 2 Hz. You should not have to override this parameter.  

**`taperWindowSize`**  
Taper sliding window length in seconds. By default, PREP uses 4 seconds. You should not have to override this parameter.  

**`taperWindowStep`**  
Taper sliding window step length in seconds. By default, PREP uses 1 second. You should not have to override this parameter.  

**`tau`**  
The window overlap smoothing factor used in the exponent of the signmoidal smoothing functions. This sigmoidal smoothing function is used to patch results from sliding windows back together. By default, PREP uses a value of 100. You should not have to override this parameter.  

**`pad`**  
Padding factor for FFTs (-1= no padding, 0 = pad to next power of 2, 1 = pad to power of two after, etc.). By default, PREP uses a pad factor of 0. A larger positive value gives better spectral results, but requires much greater computation time. Using a pad value of -1 is not recommended. You should not have to override this parameter.  

**`fPassBand`**  
The frequency band (in units of Hz) used to compute the spectral background. By default, PREP
uses `[0, Fs/2]`. You may need to adjust this range to get better spectral estimates.

**`maximumIterations`**  
The maximum number of times that PREP applies the cleaning process to remove line noise. When a particular peak
is not significantly above the background, it is removed from consideration. When no significant peaks remain, PREP
stops the procedure. Most of the time, only a few iterations are required.  You should not have to override this parameter.  

## Robust referencing
Referencing is the process of subtracting a common reference signal from all of the channels. Data sets collected
from Biosemi headsets require referencing of some sort. Other headsets benefit as well. When comparing results across
data sets, it is important to use the same referencing strategy.  

The PREP pipeline using robust average reference. This process is the same as average referencing (subtracting 
the average of the channels from each channel in each frame) provided the data set does not have any bad
channels.  However, if even if just a single channel has artifacts, the average reference can introduce
errors.  To address this, the robust reference iteratively detects and interpolates bad channels to arrive at an
average reference that is not affected by artifacts.  

### Calling sequence for referencing
The `performReference` function takes two structures in and produces two output structures. The signal structure
includes a `.data` field and an `.srate` field. The `signal` structure is compatible with an EEGLAB EEG structure, but does not rely on any of the other EEGLAB fields. The data field should be channels x frames. On output, PREP stores metadata about the referencing in the `.etc.noiseDetection` field.

As with all functions in the pipeline, the algorithm parameters are passed in a structure:  
> `[signal, referenceOut] = performReference(signal)`  
> `[signal, referenceOut] = performReference(signal, referenceIn)`  

The output structure contains all of the input structure fields plus many additional fields containing the 
reports of the output of the bad channel detection. Details in the document on PREP reporting.

**Example:**  
> `referenceIn = struct('referenceeChannels', [1:32, 40:60]);`  

### Parameters for referencing
The following parameters appear as fields in the `referenceIn` structure:  

**`referenceChannels`**  
 A row vector specifying the channel numbers of the channels to use for referencing.  By default, PREP uses all of the channels (`1:size(signal.data, 1)`). If your signal has extraneous or unused channels, you should specify which channels to use. For standard robust referencing, you should specify only the EEG channels and not EOG channels or mastoids. All of the reference channels will be used to compute the reference. If the channel is bad, PREP uses its interpolated value.  

**`evaluationChannels`**  
 A row vector specifying the channel numbers of the channels to use for evaluating noisy channels.  By default, PREP uses all of the channels (`1:size(signal.data, 1)`). If your signal has extraneous or unused channels, you should specify which channels to use. These channels should only be EEG channels. These channels are used to compute thresholds and to perform
estimates in the RANSAC algorithm. Often the reference channels and the evaluation channels are the same. However, if an EEG channel has NaNs or other unusable data, it will still be used as a reference channel, but will be excluded from the evaluation channels.  

**`rereference`**  
 A row vector specifying the channel numbers of the channels from which to subtract the computed reference.  By default, PREP uses all of the channels (`1:size(signal.data, 1)`). If your signal has extraneous or unused channels, you should specify which channels to use. Channels such as mastoids and EOG channels are usually re-referenced but are not used to 
compute the robust reference.  

**`referenceType`**  
The type of reference to be performed. By default, PREP uses ``robust'`, which computes an average reference with
iterative detection and interpolation of bad channels.  Other options include `'average'`, `'specific'`, and `'none'`.
The `'average'` type removes the average of the reference channels with no interpolation, while `'specific'` removes
the average of the specified channels with no interpolation. If you mean to run the standardized PREP pipeline,
you don't need to specify this field.  

**`interpolationOrder`**  
Specifies whether PREP performs final channel interpolation. By default, PREP uses `'post-reference'`. 
In this case, after a final robust reference is computed, the channels are re-interpolated and the reference is corrected.
In `'pre-reference'`, PREP incrementally adds to the bad channel list and interpolates before computing the reference.
If the initial estimate of the reference is poor, this is not a good approach. In the `'none'` option, PREP removes the
reference but does not interpolate. Bad channels remain in the signal. You may choose to remove them during post-processing. If you mean to run the standardized PREP pipeline, you don't need to specify this field.  

**`meanEstimateType`**  
The method used to estimate the initial mean reference. By default, PREP takes the median of the channel values
in each frame. Other options include `'mean'`, which is prone to outliers,  `'huber'` which is computationally expensive,
or `'none'`. If you mean to run the standardized PREP pipeline, you don't need to specify this field.  

**`channelLocations`**  
A structure containing the channel locations in EEGLAB `chanlocs` format. By default, PREP uses the `signal.chanlocs`
structure unless this field is used to over ride. PREP must have channel locations in order to work.  

**`channelInfo`**  
A structure containing channel information in EEGLAB `chaninfo` format. By default, PREP uses the `signal.chaninfo`
structure unless this field is used to over ride. PREP uses the nose direction for display purposes in the reports.

**`srate`**  
The sampling frequency of the signal in Hz. By default, PREP uses the sampling rate specified in `signal.srate`. Usually you don't have to specify this parameter.  

**`samples`**  
The number of frames to use for the computation. By default, PREP uses `size(signal.data, 2)`. Usually you don't have to specify this parameter.  

**`robustDeviationThreshold`**  
Z-score cutoff for robust channel deviation. If a channel has a robust deviation z-score above this value, 
PREP considers the channel to be bad in that window. By default, PREP uses 5. Usually you don't have to specify this parameter.  

**`highFrequencyNoiseThreshold`**  
Z-score cutoff for SNR (signal above 50 Hz). If a channel has a z-score of the ratio of signal above 50 Hz to that below 50 Hz, PREP considers the channel to be bad in that window. By default, PREP uses 5. Usually you don't have to specify this parameter.  

**`correlationWindowSeconds`**  
Window size in seconds for computing correlations and other window values. By default, PREP uses 1. Usually you don't have to specify this parameter.  

**`correlationThreshold`**  
Max correlation absolute threshold for channel being bad in a window. In each window, PREP computes the maximum of the absolute value of the correlation with other channels and compares to this threshold. If the correlation falls below this threshold, PREP considers the channel to be bad-by-correlation in this window. PREP also uses this window size to evaluate windowed absolute deviation and SNR. By default, PREP uses 0.4. Usually you don't have to specify this parameter.  

**`badTimeThreshold`**  
Threshold fraction of bad correlation windows for designating a channel to be bad-by-correlation. By default, PREP uses 0.01. Usually you don't have to specify this parameter.  
 
**`ransacOff`**  
If true, RANSAC is not used for bad channel detection (useful for small headsets). By default, PREP uses false. Usually you don't have to specify this parameter.  

**`ransacSampleSize`**  
Number of random matrices sampled to estimate RANSAC. By default, PREP uses 50 sample matrices. Usually you don't have to specify this parameter.  

**`ransacChannelFraction`**  
Fraction of evaluation channels RANSAC uses to predict a channel. By default, PREP uses 0.25 of the evaluation channels. Usually you don't have to specify this parameter.  

**`ransacCorrelationThreshold`**  
Cutoff correlation for unpredictability by neighbors. If the absolute correlation of the channel with its RANSAC prediction in a window falls below this threshold, the channel is designated as bad in this window. By default, PREP uses 0.75. Usually you don't have to specify this parameter.  

**`ransacUnbrokenTime`**  
Threshold fraction of windows that a channel must be bad before it is designated as a channel that is bad-by-RANSAC. By default, PREP uses 0.4. Usually you don't have to specify this parameter.  

**`ransacWindowSeconds`**  
Size of windows in seconds over which to compute RANSAC predictions. By default, PREP uses 5. Usually you don't have to specify this parameter.  

**`maxReferenceIterations`**  
Maximum number of iterations in the reference-bad channel detection-interpolation cycle. 
By default, PREP uses 4. If the actual iterations is 4, you may need to increase this or look carefully at your data set.  

**`reportingLevel`**  
How much information to store about referencing in the EEG structure. By default, PREP uses `'verbose'`, which causes
the data structure to contain all of the window information for later processing and reporting. If you use `'minimum'`, you will not be able to run the PREP reports.  Alternatively, you can choose to clean up the data structure
after running the reports.  

## Reporting
PREP has an extensive report facility that can be used provided that your reporting level was `'verbose'`. The GUI version of the PREP pipeline (`pop_prepPipeline'`) has options in the report GUI for you to select whether or not to run the report. If the report mode is `'normal'` (the default), then PREP runs the processing pipeline followed by the report, followed by the post processing. If the report mode is `'skip'`, then PREP runs the processing pipeline followed by the post processing. If the report mode is `'reportOnly'`, then PREP only runs the report and skips both the processing and the post processing.  

### Calling sequence for reporting
The `publishPrepReport` function takes an EEG structure that has been run through the PREP pipeline with
report level of verbose. You need to furnish a summary directory name and a summary file name for an HTML file with summary information for all of the stuff.

As with all functions in the pipeline, the algorithm parameters are passed in a structure.  
> `publishPrepReport(signal, summaryFilePath, sessionFilePath, consoleFID, publishOn);`  


The output structure contains all of the input structure fields plus additional fields including a string representation
of the actual command used.

**Example:**  
The following produces an HTML-formatted summary report in the current directory and publishes a detailed report in the s1 sub directory.  
> `publishPrepReport(EEG, 'vepSummary.html', '.\s1\vep01.pdf', 1, true);`  

### Parameters for reporting

**`signal`**  
The `signal` structure includes a `.data` field and an `.srate` field. The `signal` structure is compatible with an EEGLAB EEG structure, but does not rely on any of the other EEGLAB fields. The data field should be channels x frames. In order to get reports, the EEG structure must have the `.etc.noiseDetection` as PREP generates the report from information stored there.  

**`summaryFilePath`**  
The file name for the HTML summary file that PREP produces for the report. The name should include path information when needed. If `publishOn` is `false`, PREP writes the summary information to the file indicated by `consoleFID`.

**`sessionFilePath`**  
The file name for the detailed PDF report that PREP produces. The name should include path information when needed. If `publishOn` is `false`, PREP doesn't produce a report.  

**`consoleFID`**  
An open file descriptor for writing reporting information. Usually, this is 1, indicating that output should be directed to the command window. Give an open file descriptor to another file to record the report in a log.  

**`PublishOn`**  
If `true` (the default) PREP produces a published PDF Report and an HTML summary. If `false`, the PREP runs reporting, but keeps the figures displayed and outputs the reporting information to the command window. This mode is useful for closer examination of the figures.  
