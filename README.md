EEG-Clean-Tools
===============

Contains tools for the PREP pipeline for standardized preprocessing of EEG. You can
find the user documentation at
[https://vislab.github.io/EEG-Clean-Tools/](https://vislab.github.io/EEG-Clean-Tools/).

**Note:** For convenience, EEGLABPlugin directory contains the latest released version of the
PREP that can be unzipped into your EEGLAB plugins directory.  

### Building the documentation
The documentation source is in `docs/` (Sphinx, with MyST markdown). To build and
view it locally, set up a Python virtual environment once, from the repository root.
Python 3.10 or later is required.

**Windows (PowerShell):**

```powershell
python -m venv --clear .venv
.venv\Scripts\Activate.ps1
python -m pip install -e ".[docs]"
python docs/patch_matlabdomain.py
```

If PowerShell refuses to run `Activate.ps1`, allow local scripts for your account
once with `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`. In `cmd.exe`, activate
with `.venv\Scripts\activate.bat` instead.

**Linux and macOS:**

```bash
python3 -m venv --clear .venv
source .venv/bin/activate
python -m pip install -e ".[docs]"
python docs/patch_matlabdomain.py
```

On Debian and Ubuntu, `python3 -m venv` needs the `python3-venv` package
(`sudo apt install python3-venv`).

`docs/patch_matlabdomain.py` must be rerun after every reinstall of
`sphinxcontrib-matlabdomain`. In later sessions, only the activation line is needed.

With the environment activated, build and serve the site. These commands are the
same on every platform:

```shell
python -m sphinx -b html docs docs/_build/html
python -m http.server 8000 --bind 127.0.0.1 -d docs/_build/html
```

The server prints `Serving HTTP on 127.0.0.1 port 8000 (http://127.0.0.1:8000/)`.
Open that address in a browser, and stop the server with Ctrl+C. The
`--bind 127.0.0.1` keeps the server reachable only from your own machine. Opening
`docs/_build/html/index.html` directly also works, but search does not.

### Publishing the documentation
The site at https://vislab.github.io/EEG-Clean-Tools/ is served by GitHub Pages.
Pushing any branch other than `master` publishes nothing. The workflow
`.github/workflows/deploy-docs.yaml` builds the docs on pull requests to `master`
without deploying, and builds and deploys them on pushes to `master`.

That deploy only reaches the site when the repository's Pages source (Settings ->
Pages -> Source) is "GitHub Actions". While the source is "Deploy from a branch:
gh-pages", the live site is the one on the `gh-pages` branch, and the workflow
cannot replace it. Do not switch the source, or delete `gh-pages`, until the
contents of `docs/` are ready to go live: the first Actions deployment overwrites
the site at the same address.

### Citing the PREP pipeline
The PREP pipeline is freely available under the GNU General Public License (see License below).
Please cite the following publication if using:  
> Bigdely-Shamlo N, Mullen T, Kothe C, Su K-M and Robbins KA (2015)  
> The PREP pipeline: standardized preprocessing for large-scale EEG analysis  
> Front. Neuroinform. 9:16. doi: 10.3389/fninf.2015.00016  

### License
The PREP pipeline is licensed under the GNU General Public License, version 2 or
(at your option) any later version. The full text is in [LICENSE](LICENSE), and a
copy is kept with the plugin as `PrepPipeline/preplicense.txt`. Parts of the
repository come from other projects and keep their own licenses:

| Component | Location | License | Copyright |
| --- | --- | --- | --- |
| PREP pipeline | everything not listed below | GPL-2.0-or-later ([LICENSE](LICENSE)) | Kay Robbins, with contributions from Nima Bigdely-Shamlo, Christian Kothe, Tim Mullen, Jeremy Cockfield, and Cassidy Matousek |
| Chronux 2, modified | `PrepPipeline/utilities/chronux_2_modified/` | GPL-2.0 (`License.txt` in that folder) | The Chronux developers ([chronux.org](http://www.chronux.org/)) |
| Line-noise removal and local detrending, adapted from cleanline and Chronux | `PrepPipeline/utilities/cleanLineNoise.m` and the functions it calls (`removeLinesMovingWindow.m`, `fitSignificantFrequencies.m`, `calculateSegmentSpectrum.m`, `private/checkTapers.m`); `PrepPipeline/utilities/localDetrend.m` | GPL, as the code they adapt | cleanline by Tim Mullen, which builds on Chronux; adaptations by Kay Robbins |
| Spherical interpolation | `PrepPipeline/utilities/private/spherical_interpolate.m` | Permissive: use, copy, and modify, keeping the copyright notice and noting changes (file header) | Jason D.R. Farquhar; modified by Kay Robbins |
| Helpers from EEGLAB | `PrepPipeline/reporting/calculateSpectrum.m`, `reporting/helpers/finputcheck.m`, `reporting/helpers/matsel.m` | GPL-2.0-or-later (file headers) | Scott Makeig, Arnaud Delorme, and Marissa Westerfield, SCCN, UCSD |
| Filter helpers | `PrepPipeline/utilities/private/design_fir.m`, `filter_fast.m`, `filtfilt_fast.m`, `hlp_microcache.m` | GPL-2.0-or-later (file headers) | Christian Kothe, SCCN, UCSD; `filter_fast.m` includes `fftfilt.m` from Octave by John W. Eaton |
| Documentation styling and build helper | `docs/_static/custom.css`, `docs/_static/gh_icon_fix.js`, `docs/patch_matlabdomain.py`, and parts of `docs/conf.py` | MIT ([docs/license_hed_matlab.txt](docs/license_hed_matlab.txt)) | HED Standard Working Group (from hed-matlab) |
| Example EEG data | `PrepPipeline/examples/data/` | Creative Commons Attribution 4.0 International ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)) | U.S. Army Research Laboratory and the authors of the dataset; cite Robbins, Su, and Hairston, "An 18-subject EEG data collection using a visual-oddball task, designed for benchmarking algorithms and headset performance comparisons", *Data in Brief* ([article](https://www.sciencedirect.com/science/article/pii/S2352340917306285), [full data on NITRC](https://www.nitrc.org/projects/vep_eeg_raw/)) |
| Released plugin | `EEGLABPlugin/PrepPipeline<version>.zip` | As its contents, above | Each zip is a snapshot of `PrepPipeline/` at its release |

The PREP pipeline is designed and distributed for research purposes only and
should not be used for medical purposes. The authors accept no responsibility
for its use in this manner.

### People
The PREP pipeline incorporates many algorithms that were developed at
USCS SCCN over many years by Nima Bigdely-Shamlo, Tim Mullen and Christian Kothe.
Kyung Min Su performed most of the machine learning evaluation of PREP. Cassidy
Matousek and Jeremy Cockfield worked on the interfaces for the EEGLAB plugin as
well as associated visualization tools. Kay Robbins of UTSA is the lead developer and
maintainer of PREP.

### Support:    
This research was sponsored by the Army Research Laboratory and was accomplished
under Cooperative Agreement Number W911NF-10-2-0022. The views and conclusions
contained in this document/software are those of the authors and should not be interpreted
as representing the official policies, either expressed or implied, of the
Army Research Laboratory or the U.S. Government. The U.S. Government is
authorized to reproduce and distribute reprints for Government purposes
notwithstanding any copyright notation herein.

### Releases
Release history: [CHANGELOG.md](CHANGELOG.md).
