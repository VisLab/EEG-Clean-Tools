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