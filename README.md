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
The PREP pipeline is freely available under the GNU General Public License. 
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
