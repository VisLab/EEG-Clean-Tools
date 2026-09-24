---
paths:
  - ".status/**"
---

# Working in .status/

- `.status/` is gitignored: the only copy is on this machine. Never delete,
  move, or rewrite a file here without asking first. Appending is fine.
- Every markdown file written here opens with a `For humans:` summary - three
  or four sentences at the very top: what the file is and what a person needs
  to take from it.
- Nothing new is created at the `.status/` root. New material goes in
  `plans/`, `prompts/`, `notes/`, or `scratch/`.
- Only `plans/` and `prompts/` are edited in place. `notes/` is write-once.
  `decisions.md` is append-only - never rewrite an entry.
- Temporary scripts, experiments, and one-off test files go in
  `.status/scratch/` - never the repository root. `scratch/` may hold any
  file type and is deleted unread; everywhere else is markdown only.
- Do not read `archive/` unless a file is named for you.
- Filenames: lowercase ASCII, `_` as separator. Notes are
  `YYYY-MM-DD_slug.md` (date first); plans and prompts are `slug.md` - no
  date, no status word in the name.
