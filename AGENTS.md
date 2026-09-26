# EEG-Clean-Tools

Purpose: the PREP pipeline - standardized early-stage EEG preprocessing (boundary handling, detrending, line-noise removal, robust average referencing, bad-channel detection and interpolation, reporting) as a MATLAB toolbox and an EEGLAB plugin.

Not in scope: EEGLAB itself, which PREP runs inside and depends on, and the downstream analysis PREP deliberately leaves open (final high-pass filtering, ICA).

## Commands

Test framework: none. There is no test suite; `PrepPipeline/utilities/blasst/blasst_test.m` is a vendored demo script, not a test. Do not add a suite as a side effect of other work.

- Smoke check (no EEGLAB needed): `matlab -batch "addpath(genpath('PrepPipeline')); disp(getPrepVersion())"` - prints the version string, for example `PrepPipeline0.57.0`
- Run standalone: add `PrepPipeline` and its subfolders to the MATLAB path, then `[EEG, params, computationTimes] = prepPipeline(EEG, params)` on an EEGLAB `EEG` structure with channel locations. Needs EEGLAB and the Signal Processing Toolbox on the path.
- Run as a plugin: unzip `EEGLABPlugin/PrepPipeline<version>.zip` into EEGLAB's `plugins/` folder; the menu entry is Tools -> Run PREP pipeline.
- Check the plugin zip: `unzip -l EEGLABPlugin/PrepPipeline<version>.zip`
- Install the docs toolchain: `python -m venv --clear .venv`, activate it, then `python -m pip install -e ".[docs]"` and `python docs/patch_matlabdomain.py` (required after every install of `sphinxcontrib-matlabdomain`; it fixes a Sphinx 7+ incompatibility in that package). Locally, use pip and the activated `.venv`, never `uv` or `uvx`: uv misbehaves on Windows. The GitHub Actions workflows use uv, and that stays.
- Build docs: `python -m sphinx -b html docs docs/_build/html` - `.github/workflows/deploy-docs.yaml` runs the same build and publishes it to GitHub Pages on pushes to `master`

## Layout

- `PrepPipeline/` - entry points: `prepPipeline.m`, `pop_prepPipeline.m` (EEGLAB GUI wrapper), `prepPostProcess.m`, `prepReport.m`, `publishPrepReport.m`, `eegplugin_prepPipeline.m` (EEGLAB menu registration)
- `PrepPipeline/utilities/` - the algorithms (`removeTrend`, `cleanLineNoise`, `performReference`, `findNoisyChannels`, defaults, version); `chronux_2_modified/` and `blasst/` are vendored third-party code
- `PrepPipeline/reporting/` - report and collection-statistics functions
- `PrepPipeline/interface/` - the EEGLAB parameter GUIs
- `PrepPipeline/derived/`, `PrepPipeline/examples/`, `PrepPipeline/extracted/` - scripts built on the pipeline
- `EEGLABPlugin/` - the released plugin as a zip
- `docs/` - Sphinx source for the documentation site (MyST markdown and `.rst`); images in `docs/_static/images/`. `pyproject.toml` exists only to declare the docs toolchain.
- `CHANGELOG.md` - release history
- `.status/` - working notes. Gitignored; local to each machine.

## Conventions that differ from defaults

- **ASCII only** in prose, code, comments, and filenames: `-` not em or en dashes, `->` not arrows, `...` not an ellipsis character, straight quotes. Exception: genuine data (author names, dataset titles, recorded API responses) keeps whatever characters it actually contains.
- Markdown headers are sentence case: capitalize only the first word, proper nouns, and acronyms (PREP, EEG, EEGLAB, MATLAB).
- MATLAB: camelCase for functions. The file name must match the function name, so `.m` files keep their mixed case.
- The default branch is `master`, not `main`.

## Rules that are easy to get wrong

- The version exists in three places that must agree: `PrepPipeline/utilities/getPrepVersion.m` (the change log that `getPrepVersion` returns), the zip name under `EEGLABPlugin/`, and `CHANGELOG.md`. Change all three together.
- Do not reformat, lint, or ASCII-clean vendored code under `PrepPipeline/utilities/chronux_2_modified/` or `PrepPipeline/utilities/blasst/`.
- `docs/api.rst` pulls each function's help text from the comment block right after its `function` line. `docs/conf.py` shows that text preformatted, exactly as MATLAB `help` prints it, so write help for `help`, not as reStructuredText. Help placed above the `function` line does not appear there, though MATLAB `help` still finds it. Functions at the root of `PrepPipeline/` need `.. mat:currentmodule:: .` before their `mat:autofunction` directives.
- Do not change the signature of an entry-point function without discussion; EEGLAB and user scripts call them directly, and `pop_prepPipeline` writes the call into EEGLAB history.

## Related repositories

Referred to by name; none is vendored here.

- `eeglab` - the MATLAB toolbox PREP runs in, required at runtime.
- `hed-matlab` - the model for this repository's layout and documentation setup.

## Where the thinking lives

`.status/` is gitignored, so it exists only on the machine that wrote it and never in a fresh clone or worktree.

- `.status/README.md` - the index. Read this first; it lists what is active.
- `.status/decisions.md` - why things are the way they are. Read before proposing structural changes. Append entries; never rewrite one.
- `.status/plans/*.md` - active plans. Check the `Status:` header and the `[ ]` / `[x]` markers before starting work.
- `.status/local-environment.md` - this machine's paths, interpreter, and quirks. Tool-agnostic. Never copy its contents into a committed file.
- IMPORTANT: do not read `.status/archive/` unless a file is named for you. Nothing new is created at the `.status/` root.

## Working agreements

- IMPORTANT: every file written to `.status/` opens with a `For humans:` summary - three or four sentences, at the very top: what the file is and what a person needs to take from it. The same applies to a long answer in a session: lead with the conclusion.
- IMPORTANT: temporary scripts, experiments, and one-off test files go in `.status/scratch/` - **never the repository root**. Delete them when the experiment ends; anything in `scratch/` may be deleted unread.
- IMPORTANT: never delete or rewrite a file under `.status/` without asking first. Appending is fine.
- For a change spanning more than three files, write a plan to `.status/plans/` and stop for review before editing.
- When you are guessing about an external API or data format, say so explicitly rather than assuming.
- Show evidence, not assertions: the command you ran and its actual output.
- Do not commit, push, or create branches unless asked.
