# Configuration file for the Sphinx documentation builder.
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import re
from datetime import datetime, timezone

DOCS_DIR = os.path.dirname(os.path.abspath(__file__))
PREP_DIR = os.path.abspath(os.path.join(DOCS_DIR, "..", "PrepPipeline"))


def _prep_version():
    """Return the newest version listed in PrepPipeline/utilities/getPrepVersion.m."""
    path = os.path.join(PREP_DIR, "utilities", "getPrepVersion.m")
    with open(path, encoding="utf-8") as f:
        entries = re.findall(r"changeLog\((\d+)\)\.version\s*=\s*'([^']+)'", f.read())
    return max(entries, key=lambda e: int(e[0]))[1] if entries else "unknown"


# -- Project information -----------------------------------------------------

project = "PREP pipeline"
copyright = f"2014-{datetime.now(timezone.utc).year}, Kay Robbins and the PREP contributors"
author = "Kay Robbins"
version = _prep_version()
release = version

# -- General configuration ---------------------------------------------------

extensions = [
    "myst_parser",
    "sphinxcontrib.matlab",
    "sphinx.ext.autodoc",
    "sphinx_copybutton",
]

# MATLAB source: the pipeline folder. Vendored third-party code is parsed but
# not documented; api.rst lists only PREP's own entry points.
matlab_src_dir = PREP_DIR
matlab_short_links = True
matlab_auto_link = True
matlab_keep_package_prefix = False

primary_domain = "mat"
add_module_names = False
myst_heading_anchors = 4
myst_enable_extensions = [
    "colon_fence",
    "deflist",
    "html_image",
    "linkify",
    "substitution",
]

templates_path = ["_templates"]
source_suffix = {".rst": "restructuredtext", ".md": "markdown"}
master_doc = "index"
exclude_patterns = ["_build", "_templates", "Thumbs.db", ".DS_Store"]

# -- Options for HTML output -------------------------------------------------

pygments_style = "sphinx"
pygments_dark_style = "monokai"

html_theme = "furo"
html_title = f"PREP pipeline {version}"

html_theme_options = {
    "light_css_variables": {
        "color-brand-primary": "#0969da",
        "color-brand-content": "#0969da",
    },
    "dark_css_variables": {
        "color-brand-primary": "#58a6ff",
        "color-brand-content": "#58a6ff",
    },
    "source_repository": "https://github.com/VisLab/EEG-Clean-Tools/",
    "source_branch": "master",
    "source_directory": "docs/",
}

html_sidebars = {
    "**": [
        "sidebar/brand.html",
        "sidebar/search.html",
        "sidebar/scroll-start.html",
        "sidebar/navigation.html",
        "quicklinks.html",
        "sidebar/scroll-end.html",
    ]
}

html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_js_files = ["gh_icon_fix.js"]


# -- MATLAB help text ---------------------------------------------------------

# PREP's help text is written for MATLAB's `help` command: aligned columns and
# indented continuation lines, not reStructuredText. Parsed as reST it renders
# badly and produces docutils warnings, so show each docstring as a literal
# block - the same text, laid out exactly as `help` prints it.


_ROLE = re.compile(r":[a-z]+:`([^`]+)`")
_LITERAL = re.compile(r"``([^`]+)``")


def _help_text_as_literal(app, what, name, obj, options, lines):
    if not any(line.strip() for line in lines):
        return
    # matlabdomain rewrites "See also" names into :func:`x` / ``x`` markup,
    # which a literal block would show verbatim; restore the plain names.
    plain = [_LITERAL.sub(r"\1", _ROLE.sub(r"\1", line)) for line in lines]
    body = [("    " + line) if line.strip() else "" for line in plain]
    lines[:] = ["::", "", *body, ""]


def setup(app):
    app.connect("autodoc-process-docstring", _help_text_as_literal)
