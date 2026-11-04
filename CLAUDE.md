@AGENTS.md

@.status/local-environment.md

# Claude Code

`AGENTS.md`, imported above, is the whole instruction set. `.status/local-environment.md`, also imported, holds this machine's paths and quirks for every tool; it is gitignored, and a clone without it loads cleanly. Path-scoped rules in `.claude/rules/` load when a session touches files matching their `paths:` globs - for example, `status_conduct.md` applies under `.status/`. After changing an import, run `/context` and confirm the file appears under **Memory files**.
