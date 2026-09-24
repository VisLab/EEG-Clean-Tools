@AGENTS.md

# Claude Code

- Path-scoped rules live in `.claude/rules/` and load automatically when a session touches files matching their `paths:` globs - for example, `status_conduct.md` applies under `.status/`. Nothing needs to reference them; this note exists so a reader knows they are there.
- `CLAUDE.local.md` (gitignored) holds notes about this machine's Claude Code setup and imports `.status/local-environment.md`, which is where machine facts live for every tool, not just this one.
- After changing either import, run `/context` and confirm the file appears under **Memory files**.
