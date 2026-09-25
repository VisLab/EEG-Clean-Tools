API reference
=============

The public entry points of the PREP pipeline. Each function's documentation is
taken from the help text in its ``.m`` file.

Running the pipeline
--------------------

.. mat:currentmodule:: .

.. mat:autofunction:: prepPipeline

.. mat:autofunction:: pop_prepPipeline

.. mat:autofunction:: prepPostProcess

Pipeline steps
--------------

.. mat:autofunction:: utilities.removeTrend

.. mat:autofunction:: utilities.cleanLineNoise

.. mat:autofunction:: utilities.performReference

.. mat:autofunction:: utilities.findNoisyChannels

.. mat:autofunction:: utilities.robustReference

.. mat:autofunction:: utilities.interpolateChannels

Defaults and version
--------------------

.. mat:autofunction:: utilities.getPrepDefaults

.. mat:autofunction:: utilities.outputPrepDefaults

.. mat:autofunction:: utilities.getPrepVersion

Reporting
---------

.. mat:currentmodule:: .

.. mat:autofunction:: prepReport

.. mat:autofunction:: publishPrepReport

.. mat:autofunction:: reporting.extractReferenceStatistics

.. mat:autofunction:: reporting.createCollectionStatistics
